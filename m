Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326D842A16A;
	Fri, 17 Jul 2026 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298914; cv=none; b=Qto+jqG0tbCL4woK7zIj4GaxHU6ikQwcC3eHRi7b2hgLmLPV7PBLdcXKPw8iVt2aKBogVaUET5EQwAaFgmRXquaT+AejrCnFbPeG74qQQuh5sRdVDrcOVBiCc2BYwgKHBGt5nC1FMhi7VGwb3TcD7uIAE6oQby/V7szwxDxaVyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298914; c=relaxed/simple;
	bh=hxGmcHmTQSG/tdRRf+oOX+HiB6sZ5o3RY6F7qAn0Qg8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tWwwPwlETNarimWjokbm5xoUf9ANjKC3uLwU2fDayEY6fHO2mN36WuvAuj2qQOzK3eZbpQHgBiXFWVBNyvadwARYYtDuTK6p1kjzx5IS6KpM0avmcoRwSSVAB95cwWwjZ1Ihch1TOlocV6PYQ/W2LmOJf0IXphIdNN8J/n/lT+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=podJ7VXE; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="podJ7VXE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1784298912;
	bh=hxGmcHmTQSG/tdRRf+oOX+HiB6sZ5o3RY6F7qAn0Qg8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=podJ7VXEOrozW0/nEkVk5DUdZHQ+jKSQ6mLUbZdvS3I1Wu4OjMzk94KILfZv/XDzH
	 Ec/FKjwkDHi4qBngcOq9TDTwLIi7MsReMG/FnZhBNLpB6oXFaxJIMafGhoAw1chHHg
	 m2Heto7gdDUeUaH+Dkyw2JU4hBcyj2zcgXY27FjQ=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8c71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 6AF891C0278;
	Fri, 17 Jul 2026 10:35:11 -0400 (EDT)
Message-ID: <570f82e8b8bc968a31a4ba859145f6c324e41247.camel@HansenPartnership.com>
Subject: Re: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: =?ISO-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>, Paolo Bonzini
	 <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Tom Lendacky	
 <thomas.lendacky@amd.com>, ashish.kalra@amd.com, michael.roth@amd.com, 
	nsaenz@amazon.com, anelkz@amazon.de, Melody Wang <huibo.wang@amd.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 x86@kernel.org, 	coconut-svsm@lists.linux.dev, joerg.roedel@amd.com
Date: Fri, 17 Jul 2026 10:35:10 -0400
In-Reply-To: <aigE2EvJyZlYDz0V@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
	 <20260608144252.351443-36-joro@8bytes.org>
	 <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com>
	 <aib8n5lO6HKbLC4Y@8bytes.org>
	 <CABgObfbUsDeStnZF-7oyR-W-Bvd4qTMoeUwGizgn10UTdKtZ2A@mail.gmail.com>
	 <aigE2EvJyZlYDz0V@8bytes.org>
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

On Tue, 2026-06-09 at 14:37 +0200, J=C3=B6rg R=C3=B6del wrote:
> I read a bit more about VSM and it seems their prioritization of VTLs
> is a bit more complicated. VTL0 has the least privileges but boots
> first, then sets up VTL1. But VTL1 is only higher-privileged once it
> is locked by VTL0. Another way to look at it is that VTL0 de-
> prioritizes itself.

Actually, I don't think we have to follow the VSM model.  All we at
Microsoft care about is that we can emulate VSM with the planes
primitives provided.

There's a definite reason not to do strict VTL privilege in that one
can see two mutually distrusting planes sharing a common communication
area.  This is definitely possible with TDX and so planes shouldn't
disallow it.

> The patches here are built around the assumption that plane0 is the
> highest privileged one and is always runnable. Running any lower-
> privilege plane must be triggered by the guest. This is clearly not
> sufficient for VSM, the question is how to solve that.

So this all depends how the planes are started.  If you're starting
them from an IGVM file that loads the most privileged code and then
runs the guest in a different plane, absolutely, it can work as you
describe.  However, the common use case for serviceable security
enclaves is you start the kernel first (necessarily in plane 0) and
then bring up the enclaves later which means the planes > 0 are
technically higher privilege since they're running hidden security
code.  HOWEVER, there's no reason at all to trust a security enclave
that's doing something like guarding private keys to be able to poke
anywhere it wants in the guest ... that's a security breach waiting to
happen, so it would really be better if the model were not
hierarchical, but more akin to the ability to seal planes off from each
other, so the kernel can start the enclave, which would then set itself
and the communication area up, but then the plane 0 kernel would remove
access to most memory from the enclave.

In this sealing model, there's no absolute privilege levels; each plane
would decide what the other planes can see of its memory space and, on
security grounds, we'd likely configure the enclaves to have the least
possible privilege.

Now, Windows applications expect VSM to be strictly hierarchical in
terms of privilege, but if we create a sealing primitive as described
above, we can get it to build the strict VSM privilege hierarchy in the
hyper-v driver.

Regards,

James
