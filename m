Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B04C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jan 2022 15:34:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2A2C49F31;
	Mon, 17 Jan 2022 10:34:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aSHTSKeWzxG5; Mon, 17 Jan 2022 10:34:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3889F49F09;
	Mon, 17 Jan 2022 10:34:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F8D149EFC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 10:34:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id li2Dt86WFGWS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jan 2022 10:34:18 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A9A149DED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 10:34:18 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Ej0IsrWC2wCxA4GIW5OMKhB0FwAJ2NYQgBUaHHkunbo=; b=uJpWH1J1AgCOxNMnBvjBDztsCB
 YUFV5BjRYvdGp/e56S5SISDl8nB7K3fys4fgmMeu66sbU0GOoXuvvWqbwQR7paXNHCzmyupYvHrYd
 eqzwjYptt9C+cvqpDFPSr1UMHJ2cIoNPquOcMo2asAJeDFejZA3WWrtJ91ZZ25z2L6RakKYkOQLZn
 hsQmFcSh2Pv4TWjFiTXdFQrBh6vGIpD+e7vcSlua1hMs3fK/++DJA1gRJW/FqW5Fi/6QMOtFexdGb
 jNUfnvRh2oLlYDCHNL78tGNYc1lhu54LF3gX4iiTN+lQAiUZOlBswS1dxvn9e8wY2cBWLYrc0iuf7
 kNhN05vA==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56724)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1n9U1K-0002m7-DJ; Mon, 17 Jan 2022 15:34:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1n9U1C-0003Pv-V1; Mon, 17 Jan 2022 15:34:02 +0000
Date: Mon, 17 Jan 2022 15:34:02 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 02/69] KVM: arm64: Move pkvm's special 32bit handling
 into a generic infrastructure
Message-ID: <YeWMaj2shSMVXgAE@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-3-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Nov 29, 2021 at 08:00:43PM +0000, Marc Zyngier wrote:
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index c0e3fed26d93..d13115a12434 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -233,7 +233,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
>   * Returns false if the guest ran in AArch32 when it shouldn't have, and
>   * thus should exit to the host, or true if a the guest run loop can continue.
>   */
> -static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)

The comment above this function needs fixing up - it talks about the
return value, but this patch changes the return type to be void.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
