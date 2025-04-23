Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F342918F6
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 19:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745435502; cv=none; b=Bj7lIa3BKFnb69ZFyivPZFoMCDdEgOQOnHsPWFiL8nFwJS1iCZkJmfsMJuKT1OIR/YPyT4cqyvV9E/ePr96YvviKZxZzC3mXhJzz748pcXvCk+4AXatHZ7MKVPxRy497GQLZ79ke8TXSb236y9J4fm0ZoFRGm81wcBRZNrMakRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745435502; c=relaxed/simple;
	bh=1A9Kpn5gWDgTPpGdW+Bqy4gqqJlhVZpY4wvKxWo1xec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6QzbG+2fFdtYB/vgR74JMGYy/Kp/dWWJaOpDK+YaiD84Q/7ykACO9UtE5ktYdXn7KmlwR9ZTJBCpq5tX+44tU30OGAgZzKZHLI1/M4ONj4qiX0heHMOWWmQTH5fgch8q3q/2C4rrgdJRTwx37hvafJvFTgCKnbHkh21HKcAqXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=gR+JBAJ2; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="gR+JBAJ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ehGug8WvDyCD5M5pIZOyKV928YDmAC5y0+gfYQ09jXs=; b=gR+JBAJ2qYXt394sKZwRWQbCpN
	HcCePrKHfFGuCBW/CVsEGeyPPPBU/OQFtTsArQ9YAQMdfrPO91pRpinnkaU+R3jp+UdCphKe75jFH
	ucyYXyXAR2foVu/mfhe3HwUcFVAYNSC0D2IF/239fM2PkQuMT0/jZ9Eup36+0LE43cVft0e9OZxx5
	dDTM3b1WXjpuJEb+/LCJQPWrlgDi1mUkEElwET/A/fla7O5FXGgwS0k0+1m++lZoElXyOp6z21cIM
	PjsApZ3zXuvkQ0rQfUsItb9D7TVFm1pADJUTTToBoUfafozF64nMdonx3qfC29IHEpO7FhUsX84Zq
	V3eCi9ZA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52066)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1u7fVE-0006RY-0p;
	Wed, 23 Apr 2025 20:11:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.96)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1u7fV8-0000JD-0y;
	Wed, 23 Apr 2025 20:11:18 +0100
Date: Wed, 23 Apr 2025 20:11:18 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Yury Norov <yury.norov@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Luo Jie <quic_luoj@quicinc.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org,
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, andrew@lunn.ch, quic_kkumarcs@quicinc.com,
	quic_linchen@quicinc.com, quic_leiwei@quicinc.com,
	quic_suruchia@quicinc.com, quic_pavir@quicinc.com
Subject: Re: [PATCH v3 4/6] arm64: nvhe: Convert the opencoded field modify
Message-ID: <aAk7VqNOLujcyZS0@shell.armlinux.org.uk>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <20250417-field_modify-v3-4-6f7992aafcb7@quicinc.com>
 <86r01rjald.wl-maz@kernel.org>
 <aAJsaNdznnz-1qap@yury>
 <aAkn8lvzoa1grdkt@shell.armlinux.org.uk>
 <aAkw-tFctkk3xyS8@yury>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAkw-tFctkk3xyS8@yury>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Wed, Apr 23, 2025 at 02:27:06PM -0400, Yury Norov wrote:
> On Wed, Apr 23, 2025 at 06:48:34PM +0100, Russell King (Oracle) wrote:
> > On Fri, Apr 18, 2025 at 11:14:48AM -0400, Yury Norov wrote:
> > > On Thu, Apr 17, 2025 at 12:23:10PM +0100, Marc Zyngier wrote:
> > > > On Thu, 17 Apr 2025 11:47:11 +0100,
> > > > Luo Jie <quic_luoj@quicinc.com> wrote:
> > > > > 
> > > > > Replaced below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
> > > > > - reg &= ~MASK;
> > > > > - reg |= FIELD_PREP(MASK, val);
> > > > > The semantic patch that makes this change is available
> > > > > in scripts/coccinelle/misc/field_modify.cocci.
> > > > > 
> > > > > More information about semantic patching is available at
> > > > > https://coccinelle.gitlabpages.inria.fr/website
> > > > > 
> > > > > Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
> > > > > ---
> > > > >  arch/arm64/kvm/hyp/include/nvhe/memory.h | 3 +--
> > > > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > > index 34233d586060..b2af748964d0 100644
> > > > > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > > @@ -30,8 +30,7 @@ enum pkvm_page_state {
> > > > >  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> > > > >  						 enum pkvm_page_state state)
> > > > >  {
> > > > > -	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> > > > > -	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> > > > > +	FIELD_MODIFY(PKVM_PAGE_STATE_PROT_MASK, &prot, state);
> > > > >  	return prot;
> > > > >  }
> > > > 
> > > > Following up on my suggestion to *not* add anything new, this patch
> > > > could be written as:
> > > > 
> > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > index 34233d5860607..08cb6ba0e0716 100644
> > > > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > > > @@ -30,9 +30,8 @@ enum pkvm_page_state {
> > > >  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> > > >  						 enum pkvm_page_state state)
> > > >  {
> > > > -	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> > > > -	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> > > > -	return prot;
> > > > +	u64 p = prot;
> > > > +	return u64_replace_bits(p, state, PKVM_PAGE_STATE_PROT_MASK);
> > > >  }
> > > 
> > > This is a great example where u64_replace_bit() should NOT be used. 
> > 
> > Why not? Explain it. Don't leave people in the dark, because right
> > now it looks like it's purely a religous fanaticism about what
> > should and should not be used. Where's the technical reasoning?
> 
> Because enum is an integer, i.e. 32-bit type.

This statement is false, in this case.

The kernel currently uses -std=gnu11, and GNU tends to be more relaxed
about things, and while the C standard may say that enums are ints,
that isn't the case - gcc appears to follow C++ and allow enums that
are wider than ints.

$ aarch64-linux-gnu-gcc -S -o - -std=gnu99 -x c -
enum foo {
A = 1L << 0,
B = 1L << 53,
};
int main()
{ return sizeof(enum foo); }

Gives the following code:

main:
.LFB0:
        .cfi_startproc
        mov     w0, 8
        ret
        .cfi_endproc

meaning that sizeof(enum foo) is 8 or 64-bit.

If B were 1L << 31, then sizeof(enum foo) is 4.

> Now, the snippet above
> typecasts it to 64-bit fixed size type, passes to 64-bit fixed-type
> function, and the returned value is typecasted back to 32-bit int.

In this case, the enum is defined using:

        KVM_PGTABLE_PROT_X                      = BIT(0),
        KVM_PGTABLE_PROT_W                      = BIT(1),
        KVM_PGTABLE_PROT_R                      = BIT(2),

        KVM_PGTABLE_PROT_DEVICE                 = BIT(3),
        KVM_PGTABLE_PROT_NORMAL_NC              = BIT(4),

        KVM_PGTABLE_PROT_SW0                    = BIT(55),
        KVM_PGTABLE_PROT_SW1                    = BIT(56),
        KVM_PGTABLE_PROT_SW2                    = BIT(57),
        KVM_PGTABLE_PROT_SW3                    = BIT(58),

As it contains bits beyond bit 31, and we use -std=gnu11 when building
the kernel, this enum is represented using a 64-bit integer type. So,
the casting to a u64 is not increasing the size of the enum, and the
return value is not getting truncated down to 32-bits.

> Doesn't sound the most efficient solution, right? On 32-bit arch it
> may double the function size, I guess.

Given that there's no inefficiency here, and that this is arm64 code
which is a 64-bit arch, both those points you mention seem to be
incorrect or not relevant.

> But the most important is that if we adopt this practice and spread it
> around, it will be really easy to overflow the 32-bit storage. The
> compiler will keep silence about that.

Given that in Marc's suggestion, "prot" is a 64-bit value, it's being
assigned to a u64, which is then being operated on by the u64 variant
of _replace_bits(), which returns the u64 result, which then gets
returned as a 64-bit enum, there is no issue here as far as I can see.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
