From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 5/9] KVM: arm/arm64: vgic-its: Remove
 kvm_its_unmap_device
Date: Mon, 30 Oct 2017 02:49:33 +0000
Message-ID: <86inex73k2.fsf@arm.com>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
 <1509031391-4407-6-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2E5040A74
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:48:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ms69Tvvyc1AV for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Oct 2017 22:48:06 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B76BA406BB
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:48:06 -0400 (EDT)
In-Reply-To: <1509031391-4407-6-git-send-email-eric.auger@redhat.com> (Eric
 Auger's message of "Thu, 26 Oct 2017 17:23:07 +0200")
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

On Thu, Oct 26 2017 at  6:23:07 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> Let's remove kvm_its_unmap_device and use kvm_its_free_device
> as both functions are identical.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
