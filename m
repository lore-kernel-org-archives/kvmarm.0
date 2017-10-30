From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 6/9] KVM: arm/arm64: vgic-its: New helper functions to
 free the caches
Date: Mon, 30 Oct 2017 03:20:21 +0000
Message-ID: <86a809724q.fsf@arm.com>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
 <1509031391-4407-7-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96C2549D1B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 23:18:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TWoObdZTE+1p for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Oct 2017 23:18:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A485B406BB
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 23:18:53 -0400 (EDT)
In-Reply-To: <1509031391-4407-7-git-send-email-eric.auger@redhat.com> (Eric
 Auger's message of "Thu, 26 Oct 2017 17:23:08 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, cdall@linaro.org, andre.przywara@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 26 2017 at  6:23:08 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> From: wanghaibin <wanghaibin.wang@huawei.com>
>
> We create two new functions that free the device and
> collection lists. They are currently called by vgic_its_destroy()
> and other callers will be added in subsequent patches.
>
> We also remove the check on its->device_list.next.
> Lists are initialized in vgic_create_its() and the device
> is added to the device list only if this latter succeeds.
>
> vgic_its_destroy is the device destroy ops. This latter is called
> by kvm_destroy_devices() which loops on all created devices. So
> at this point the list is initialized.
>
> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
