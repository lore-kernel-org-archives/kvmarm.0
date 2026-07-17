Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DD036C588;
	Fri, 17 Jul 2026 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303779; cv=none; b=Dql+tDdlH5ZQD7v342z9gPUqEE78WrzlezDgvsN0VpVPTLVEtlWKX9EVb9572kAYWxzSAsAuj0g5oz8SRAAk7bcj31BYys4zrF/T7SivE4IpMlG3DO3UJqQCmf4o6IJgWgDM2pHWj+0q+UAepR8d7RBlRhcLACEH3yGWtTBQgZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303779; c=relaxed/simple;
	bh=8E/aCvafBerjGcyt/czXHn8A+QbSJiP1ZLClAh2Nqf8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J12Q+7rjzK002YgS3po8G6mizmeQugLrZ1NDPnUmSc0vEToqW472ZgnyF1wxg59DvWO6E2DNm7JBI0lJsw/ON7C87pFA58Kz5BV8tdd4eOAWKFT/f77XNS4sjMgx4qz1jHfhoVTxNDJ58qyfXXGCQ/EJPPagzohjIS21XmIGYWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=pE4JSA7L; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="pE4JSA7L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1784303776;
	bh=8E/aCvafBerjGcyt/czXHn8A+QbSJiP1ZLClAh2Nqf8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=pE4JSA7LDo31TtOH6lVhRGLmgo69Rq7uIrlsGvhRqaaCuqGH7NIbVKEBzPNgbzlr0
	 HfhhSUxH3Jy6Mco8uMYCXMhJUMKRW6EZYi47aVY5QkDAHN2pfU1WiTnh9hqOrO5bQR
	 i7p7VxY4n38UceajEGhvjud0cMrlCjcs/V9aUfxM=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8c71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id AA4091C029F;
	Fri, 17 Jul 2026 11:56:15 -0400 (EDT)
Message-ID: <976f1a8316438d5b7c2f446a0369dcda3289cc92.camel@HansenPartnership.com>
Subject: Re: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Saenz Julienne, Nicolas" <nsaenz@amazon.es>, 
 =?ISO-8859-1?Q?J=F6rg_R=F6del?=
	 <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Tom Lendacky	
 <thomas.lendacky@amd.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>, 
 "michael.roth@amd.com"	 <michael.roth@amd.com>, "Orazgaliyeva, Anel"
 <anelkz@amazon.de>, Melody Wang	 <huibo.wang@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
 "linux-kernel@vger.kernel.org"	 <linux-kernel@vger.kernel.org>,
 "kvmarm@lists.linux.dev"	 <kvmarm@lists.linux.dev>,
 "loongarch@lists.linux.dev"	 <loongarch@lists.linux.dev>,
 "linux-mips@vger.kernel.org"	 <linux-mips@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org"	 <linuxppc-dev@lists.ozlabs.org>,
 "kvm-riscv@lists.infradead.org"	 <kvm-riscv@lists.infradead.org>,
 "x86@kernel.org" <x86@kernel.org>,  "coconut-svsm@lists.linux.dev"	
 <coconut-svsm@lists.linux.dev>, "joerg.roedel@amd.com"
 <joerg.roedel@amd.com>
Date: Fri, 17 Jul 2026 11:56:15 -0400
In-Reply-To: <DK0W6G329B6W.2KGT7FAVSKNYS@amazon.com>
References: <20260608144252.351443-1-joro@8bytes.org>
	 <20260608144252.351443-36-joro@8bytes.org>
	 <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com>
	 <aib8n5lO6HKbLC4Y@8bytes.org>
	 <CABgObfbUsDeStnZF-7oyR-W-Bvd4qTMoeUwGizgn10UTdKtZ2A@mail.gmail.com>
	 <aigE2EvJyZlYDz0V@8bytes.org> <DK0W6G329B6W.2KGT7FAVSKNYS@amazon.com>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2026-07-17 at 13:48 +0000, Saenz Julienne, Nicolas wrote:
> Hi Joerg, I'm a bit late to the discussion hope it helps nonetheless,
>=20
> On Tue Jun 9, 2026 at 2:37 PM CEST, J=C3=B6rg R=C3=B6del wrote:
> > CAUTION: This email originated from outside of the organization. Do
> > not click links or open attachments unless you can confirm the
> > sender and know the content is safe.
> >=20
> > > The idea of the userspace scheduling was that you're not forced
> > > to use it - the kernel can always choose to override it if it's
> > > using an accelerated implementation of planes (and of plane
> > > switching). But it also leaves some leeway to different
> > > accelerated implementations, each of which can pick their own
> > > algorithm.
> > >=20
> > > Conceptually I'd rather keep the possibility of userspace
> > > scheduling. But maybe it doesn't add much.
> >=20
> > My preference is to keep plane scheduling at one place (in the
> > kernel) to keep it simple. But if you see a need for user-mode to
> > interact there as well (only really works for VSM), then I can add
> > it.
>=20
> The responsibility split we had in mind when we built a VSM emulation
> prototype [1] was to keep all VTL policing in user-space. This
> includes VTL switching, Cross VTL IPIs, Intercepts (Memory, MSRs,
> Insns, CPU regs), VTL aware SMP bring-up, etc. Even with KVM Planes
> in place, my thinking was to keep it as such. While all this could be
> implemented in the kernel, in practical terms, I think it'll be
> easier to get VSM support upstream the more we move the
> implementation into user-space.

I looked at the kernel bit.  The vsm/dev branch contains 72 patches
over 6.12 which is quite a lot ...

However, from a quick skim, the main thing is that you used multiple
KVM structures to manage the planes which means each plane naturally
gets its own address space.  In the current planes model so far there's
only one address space (or two if you have SMM).  SNP doesn't need
anything above this because the VMPL protection is naturally managed
inside the guest (so not really visible to the host) but a VTL
implementation will.  So I think the big question becomes how are we
going to achieve address space separation for planes?  It's tempting to
say simply one address space per plane and make SMM its own plane with
different switching but it's an awful lot of overhead especially as
most VMs won't even use planes, so it looks like there has to be a more
opportunistic model for planes address spaces.

> More importantly, I think the area of Virtualization Based Security
> would benefit from a versatile Planes implementation. Forcing
> specific plane switching semantics might prevent the introduction VSM
> alternatives or extensions. Heki and lVBS come to mind here.
>=20
> > I read a bit more about VSM and it seems their prioritization of
> > VTLs is a bit more complicated. VTL0 has the least privileges but
> > boots first, then sets up VTL1. But VTL1 is only higher-privileged
> > once it is locked by VTL0. Another way to look at it is that VTL0
> > de-prioritizes itself.
> >=20
> > The patches here are built around the assumption that plane0 is the
> > highest privileged one and is always runnable. Running any lower-
> > privilege plane must be triggered by the guest. This is clearly not
> > sufficient for VSM, the question is how to solve that.
>=20
> I'd suggest inverting the priorities, with higher planes being more
> privileged. It'll make introducing higher privilege levels easier.
> This is especially useful with VSM, where it's not possible to know
> how many levels will be enabled before launching the VM.

I already addressed this in a different reply

https://lore.kernel.org/kvm/570f82e8b8bc968a31a4ba859145f6c324e41247.camel@=
HansenPartnership.com/

but basically I think hierarchical privilege will be too limiting.  I
agree we need to have enough primitives to bring up hierarchical VSMs
if that's what the guest wants (Windows definitely will) but this
shouldn't be the only thing we can arrange planes as.  The mutually
distrusting model has a lot going for it in terms of security
properties.

Regards,

James
