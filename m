From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Enable direct irqfd MSI injection
Date: Mon, 18 Mar 2019 13:30:40 +0000
Message-ID: <20190318133040.1cfad9a4@why.wild-wind.fr.eu.org>
References: <1552833373-19828-1-git-send-email-yuzenghui@huawei.com>
 <86o969z42z.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 613DD4A477
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Mar 2019 09:30:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PPWXg8c6rhE1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Mar 2019 09:30:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 064DF4A441
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Mar 2019 09:30:51 -0400 (EDT)
In-Reply-To: <86o969z42z.wl-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: mst@redhat.com, kvm@vger.kernel.org, "Raslan,
 KarimAllah" <karahmed@amazon.de>, andre.przywara@arm.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, 17 Mar 2019 19:35:48 +0000
Marc Zyngier <marc.zyngier@arm.com> wrote:

[...]

> A first approach would be to keep a small cache of the last few
> successful translations for this ITS, cache that could be looked-up by
> holding a spinlock instead. A hit in this cache could directly be
> injected. Any command that invalidates or changes anything (DISCARD,
> INV, INVALL, MAPC with V=0, MAPD with V=0, MOVALL, MOVI) should nuke
> the cache altogether.

And to explain what I meant with this, I've pushed a branch[1] with a
basic prototype. It is good enough to get a VM to boot, but I wouldn't
trust it for anything serious just yet.

If anyone feels like giving it a go and check whether it has any
benefit performance wise, please do so.

Thanks,

	M.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/its-translation-cache
-- 
Without deviation from the norm, progress is not possible.
