From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 8/9] KVM: arm/arm64: Document KVM_DEV_ARM_ITS_CTRL_RESET
Date: Mon, 30 Oct 2017 03:21:53 +0000
Message-ID: <8660ax7226.fsf@arm.com>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
 <1509031391-4407-9-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28DC249D20
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 23:20:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zAifMG3869Ho for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Oct 2017 23:20:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07A77406BB
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 23:20:27 -0400 (EDT)
In-Reply-To: <1509031391-4407-9-git-send-email-eric.auger@redhat.com> (Eric
 Auger's message of "Thu, 26 Oct 2017 17:23:10 +0200")
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

On Thu, Oct 26 2017 at  6:23:10 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> At the moment, the in-kernel emulated ITS is not properly reset.
> On guest restart/reset some registers keep their old values and
> internal structures like device, ITE, and collection lists are not
> freed.
>
> This may lead to various bugs. Among them, we can have incorrect state
> backup or failure when saving the ITS state at early guest boot stage.
>
> This patch documents a new attribute, KVM_DEV_ARM_ITS_CTRL_RESET in
> the KVM_DEV_ARM_VGIC_GRP_CTRL group.
>
> Upon this action, we can reset registers and especially those
> pointing to tables previously allocated by the guest and free
> the internal data structures storing the list of devices, collections
> and lpis.
>
> The usual approach for device reset of having userspace write
> the reset values of the registers to the kernel via the register
> read/write APIs doesn't work for the ITS because it has some
> internal state (caches) which is not exposed as registers,
> and there is no register interface for "drop cached data without
> writing it back to RAM". So we need a KVM API which mimics the
> hardware's reset line, to provide the equivalent behaviour to
> a "pull the power cord out of the back of the machine" reset.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reported-by: wanghaibin <wanghaibin.wang@huawei.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
