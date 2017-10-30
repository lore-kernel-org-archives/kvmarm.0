From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 0/9] vITS Migration fixes and reset
Date: Mon, 30 Oct 2017 08:59:36 +0100
Message-ID: <cd3ef7af-38c1-fa3a-0ebc-5b731857865b@redhat.com>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
 <20171030062032.GL2166@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5F7649D19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 03:58:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z5XqQ3HBqYxc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Oct 2017 03:58:11 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B3C6406D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 03:58:11 -0400 (EDT)
In-Reply-To: <20171030062032.GL2166@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 30/10/2017 07:20, Christoffer Dall wrote:
> Hi Eric,
> 
> On Thu, Oct 26, 2017 at 05:23:02PM +0200, Eric Auger wrote:
>> This series fixes various bugs observed when saving/restoring the
>> ITS state before the guest writes the ITS registers (on first boot or
>> after reset/reboot).
>>
>> This is a follow up of Wanghaibin's series [1] plus additional
>> patches following additional code review. It also proposes one
>> ITS reset implementation.
>>
>> Currently, the in-kernel emulated ITS is not reset. After a
>> reset/reboot, the ITS register values and caches are left
>> unchanged. Registers may point to some tables in guest memory
>> which do not exist anymore. If an ITS state backup is initiated
>> before the guest re-writes the registers, the save fails
>> because inconsistencies are detected. Also restore of data saved
>> as such moment is failing.
>>
>> Patches [1-4] are fixes of bugs observed during migration at
>> early guets boot stage.
>> - handle case where all collection, device and ITT entries are
>>   invalid on restore (which is not an error)
>> - Check the GITS_BASER<n> valid bit before attempting the save
>>   any table
>> - Check the GITS_BASER<n> and GITS_CBASER are valid before enabling
>>   the ITS
>>
>> Patches [5-9] allow to empty the caches on reset and implement a
>> new ITS reset IOCTL
> 
> I applied patches 1-4 to kvmarm/master and included them in a late pull
> request to kvm.
> 
> I also took the remaining patches with the adjusted comment in
> kvmarm/next.

OK Thanks.
> 
> One question:  Don't we have a remaining issue to support saving the
> collection table even if the device table is inconsistent and vice
> versa?  Are you planning on picking up that work?

Actually to make it clear, patches 1-4 don't fix all failures but we
discussed at KVM forum that we shouldn't try to fix all of them without
a proper ITS reset implementation. So indeed even with patches 1-4 you
can get the migration failing as the save can happen after a reset,
in-between the collection creation and the PCIe device MSI registration.
This happens because the caches are not void and the L1 device table
entries are not valid. In that case the device table save fails and we
get no chance to save the collection as we abort the save immediately.
So on restore, guest will not work properly.

But on top of kvmarm/next, caches are void and we shouldn't face this
issue anymore. So in case the device table save fails, I think it still
makes sense to return an error.

But this means that the migration of ITS at early guest boot stage only
is fixed on kvmarm/next.

Thanks

Eric
> 
> Thanks,
> -Christoffer
> 
