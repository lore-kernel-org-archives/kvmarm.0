Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FF5C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 14:32:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63BE243C8C;
	Tue,  1 Feb 2022 09:32:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0PoAUCLRE8Xo; Tue,  1 Feb 2022 09:32:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE6F649EEE;
	Tue,  1 Feb 2022 09:32:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1825F49ECC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:32:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0YABVfVzHUCm for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 09:32:40 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50B3B43C8C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:32:40 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=I18tNObjVFDm/kZz3nk5PXOupFozTlFQM8ZlXVFWPRs=; b=XrkHdF9USSifp4SbR3sZpOZ0kz
 Oi3rg5K3Jj5wB03eUvBmUIJ8/vXxdMtjf37JlmIjTsY9QvCIm8OGDbIXaQPu+BUQSlHjH0tRsqgZL
 FH2K7sOcOVSl8qx79SSqds2hpS+K6WT+8ojS25qzquvzfo2yGJG0oO6/i7RU8uKnz/lrO+HjrN76z
 FbIdSkNyY/G+wHjIG50uF/d4Yj7lEjZs6FiBww7q7cZnf26Afopz5cIy2krYoHsCOcxon3nSeVZ8U
 02fO7PBYwYzcpz3R9eVDMJt7H73cKtAH3Lh+ne5l4GrojSutG6k8JKx3qN/fd9MGhYMKh9cEe6O5h
 fF6cOQfQ==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56966)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1nEuCw-0000hf-Bi; Tue, 01 Feb 2022 14:32:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1nEuCo-00028V-8b; Tue, 01 Feb 2022 14:32:26 +0000
Date: Tue, 1 Feb 2022 14:32:26 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 07/64] KVM: arm64: nv: Handle HCR_EL2.NV system
 register traps
Message-ID: <YflEev8U2xJCIwtm@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-8-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-8-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Jan 28, 2022 at 12:18:15PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> ARM v8.3 introduces a new bit in the HCR_EL2, which is the NV bit. When
> this bit is set, accessing EL2 registers in EL1 traps to EL2. In
> addition, executing the following instructions in EL1 will trap to EL2:
> tlbi, at, eret, and msr/mrs instructions to access SP_EL1. Most of the
> instructions that trap to EL2 with the NV bit were undef at EL1 prior to
> ARM v8.3. The only instruction that was not undef is eret.
> 
> This patch sets up a handler for EL2 registers and SP_EL1 register
> accesses at EL1. The host hypervisor keeps those register values in
> memory, and will emulate their behavior.
> 
> This patch doesn't set the NV bit yet. It will be set in a later patch
> once nested virtualization support is completed.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: EL2_REG() macros]
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
