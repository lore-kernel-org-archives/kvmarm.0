From: Punit Agrawal <punitagrawal@gmail.com>
Subject: Re: [PATCH v10 0/8] kvm: arm64: Support PUD hugepage at stage 2
Date: Fri, 04 Jan 2019 16:09:03 +0900
Message-ID: <87ef9s292o.fsf@gmail.com>
References: <1544548241-6417-1-git-send-email-suzuki.poulose@arm.com>
 <20181218113712.GA25383@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B388E4A2F8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 02:09:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IvGZcIIelqH5 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jan 2019 02:09:08 -0500 (EST)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
 [209.85.210.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD74C4A2E4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 02:09:07 -0500 (EST)
Received: by mail-pf1-f195.google.com with SMTP id b7so17863442pfi.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Jan 2019 23:09:07 -0800 (PST)
In-Reply-To: <20181218113712.GA25383@e113682-lin.lund.arm.com> (Christoffer
 Dall's message of "Tue, 18 Dec 2018 12:37:12 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, anshuman.khandual@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Christoffer Dall <christoffer.dall@arm.com> writes:

> On Tue, Dec 11, 2018 at 05:10:33PM +0000, Suzuki K Poulose wrote:
>> This series is an update to the PUD hugepage support previously posted
>> at [0]. This patchset adds support for PUD hugepages at stage 2 a
>> feature that is useful on cores that have support for large sized TLB
>> mappings (e.g., 1GB for 4K granule).
>> 
>> The patches are based on v4.20-rc4
>> 
>> The patches have been tested on AMD Seattle system with the following
>> hugepage sizes - 2M and 1G.
>> 
>> Right now the PUD hugepage for stage2 is only supported if the stage2
>> has 4 levels. i.e, with an IPA size of minimum 44bits with 4K pages.
>> This could be relaxed to stage2 with 3 levels, with the stage1 PUD huge
>> page mapped in the entry level of the stage2 (i.e, pgd). I have not
>> added the change here to keep this version stable w.r.t the previous
>> version. I could post a patch later after further discussions in the
>> list.
>> 
>
> For the series:
>
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>

Thanks a lot for reviewing the patches and the tag. And to Suzuki for
picking up the patchset.

(I was happy to see this while catching up with the lists after an
extended break!)
