Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA958351C30;
	Tue, 19 May 2026 11:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779189110; cv=none; b=Ux8nbI/iNiVL8uSesMUlR4c0NtA5/h3grcayptzO3NG1QTzPnHLMmoxyRVSvxRIhaK4LZvEDXeVDd8dkRW0/DLLC1ki/UZc28uGzTpZx6K9cXy3PxvR4hghSFfZ8+q/Of2etzaNt3uMFP+seoMNqQWyOCAgfv8N0HSvwJSEK3hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779189110; c=relaxed/simple;
	bh=yho1oY7rUwGUBK6N3ReIa8imE1mEl4Xep1Oe5MlRzKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5BfenvvUZQz4mWK+fVHpt6LDz1lXwAXpjofb4glXMn9mhV/iJGsCUCG71ckRje5ie4v/AAd9Mgk9UI/7gZ0j+8eaB8r5VFSA+tnl/69YpIkl5b8h/G1ose4Vg0pGRfbdT+HaNZmBYU5IpUfV7vs7RO79tYVIrMjndTRLg/LYMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIA+Mx51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZIA+Mx51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB23C2BCB3;
	Tue, 19 May 2026 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779189110;
	bh=yho1oY7rUwGUBK6N3ReIa8imE1mEl4Xep1Oe5MlRzKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZIA+Mx511B2Utvn8fqrlK5XwSL8vqCOwjgfy/t0ERyQP2GgjcHBvxaBcaz/+rZ18J
	 0CrpDV+n1qekubCKlZWpnJmE82yshPea4TnybMcHaE+QYIMwkljLEFlxIVTqMbq5dx
	 p+bEZdKaRfP4JF3HO5II7EeaBytLydOBoJQe+Zs35ZNoMdXWzyeknmt3ZRISzIfQr2
	 HPDKmcPWvg8kQiiPLq+VWUmTdcdgiXAsO6V2VXBl84LLkcAqZwz6qN9ws8wvRkwzMl
	 aeqM9OuflbaGHxAGN6ds3muEW0LgDxQKUUbyaYUZxPKXW/BMGOIMin/d5MRp7xsP3r
	 BRSjZhUoU2/xA==
Date: Tue, 19 May 2026 12:11:42 +0100
From: Will Deacon <will@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kvm <kvm@vger.kernel.org>,
	Linux Doc Mailing List <linux-doc@vger.kernel.org>,
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	kvmarm@lists.linux.dev,
	linux-kselftest <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible compatibility
 expectations
Message-ID: <agxFbniU_6eQ98t2@willie-the-truck>
References: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
 <6afc4b95-3c15-4d71-877d-19b84e91ce05@redhat.com>
 <57bc082f4824d6114d3156744c25986effc29aca.camel@infradead.org>
 <baff82ca-6321-4b16-aa61-b2d6d60b6535@redhat.com>
 <86h5obya2r.wl-maz@kernel.org>
 <48b06e5655d56ff6eda30e563b34894fa0eb2f07.camel@infradead.org>
 <ba08dfe9-932b-40c3-9fdf-fc891d52e1d8@redhat.com>
 <d9d4471a7f5ec1e297b3ca07f42a59090aa91e15.camel@infradead.org>
 <CABgObfaM-JtNn2MuYXaiadQnLfAhTEaoHAcTG9=J6LkMcQCJ3A@mail.gmail.com>
 <3f9d731c3d26b0367600f1069e6425099bc34eac.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f9d731c3d26b0367600f1069e6425099bc34eac.camel@infradead.org>

On Tue, May 19, 2026 at 11:41:26AM +0100, David Woodhouse wrote:
> On Wed, 2026-05-13 at 18:24 +0200, Paolo Bonzini wrote:
> > 
> > > See commit https://git.kernel.org/torvalds/c/49a1a2c70a7f which adds a
> > > new guest-visible feature in revision 3, but allowed userspace to
> > > restore the old behaviour by setting it to revision 2. All my patch
> > >  above does, is make it possible to set it to revision 1 as
> > > well. Because https://git.kernel.org/torvalds/c/d53c2c29ae0d previously
> > > changed the behaviour and bumped the default to 2 *without* allowing
> > > userspace to restore the prior behaviour, and we've been carrying a
> > > *revert* of that patch.
> > > 
> > > Why would we *not* accept such a patch?
> > 
> > Agreed. Even ignoring your revert, there's no reason why any upgrade
> > past 49a1a2c70a7f has to be from after d53c2c29ae0d.
> 
> So where do we go from here?
> 
> I assume you'll be taking this Documentation patch via the KVM tree?
> 
> But what about the actual fix at 
> https://lore.kernel.org/all/20260511113558.3325004-2-dwmw2@infradead.org/
> 
> This is a simple and unintrusive bug fix to make KVM/arm64 follow the
> "common sense" requirement that the doc patch codifies, apparently
> being rejected with the rather bizarre claim that KVM has no *need* to
> maintain guest-visible compatibility across host kernel changes.
> 
> So... what next? Is one of the other KVM/arm64 maintainers going to
> speak up? Paolo would you consider taking the fixes through your tree
> directly? 
> 
> Does Arm not actually *care* whether AArch64 is considered a stable and
> mature platform for KVM hosting?

Hey, come on. Marc cares more about this stuff than anybody else on the
planet. He's been single-handedly maintaining the tree for the past
couple of releases while Oliver was out and he's on the end of a _lot_
of patches. I'm only cc'd on a fraction of the KVM/arm64 changes and
it's bedlam.

Will
