Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5492F8EB4;
	Fri, 17 Jul 2026 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784312806; cv=none; b=Qgvv6MCf3FCCyV4Slc5gsgBxlIubruqVHgE1vLbHcIvdkbM0zELtastbsc6rEpeVRXvDIaM0MjypAu3720d6PudSjBL4zpQH2okxCVhZFT4p8MBXUeOfFewLu+q2oYbeVUA10XI9Z2h0QtlweXHOdwWxY0+J+o6Wrf7UEofACz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784312806; c=relaxed/simple;
	bh=j9EW4FIwSUEDfQEZzduIwipOWgGQyApHfWxvJ08O9xk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TXgf2KhoLDeJRxF3Vxht1HccwMwJuaJaEkDXnXKqNfU6n7H4q9Qrs6XdJirIqdoCuQECGUdUHcW9W5djO/5tL8OChWs2ksQNfliVq081yjw+cHdtC8K1J5FEDuSt5Cjx+kCC1dO86vnOwv5+TLs9pxs2QkVEiDvFdoSNcx1+pTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=H5D2LU12; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="H5D2LU12"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1784312803;
	bh=j9EW4FIwSUEDfQEZzduIwipOWgGQyApHfWxvJ08O9xk=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=H5D2LU12iBOHilk/nOzeUp4ZvKBs+i7bbfPhCzAA721rNfph60WER/+r4o7ApVPjk
	 wn9U4Sko57CiVWMYgrkUEqUQQf5XAbU95LhUdz6jMPiMc04p0wX4T/xVxhNPirMzjz
	 jGgvP8X9Myk6XD3stu/upYGy99g06ADfkdYj6fgM=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8c71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 186CA1C0276;
	Fri, 17 Jul 2026 14:26:43 -0400 (EDT)
Message-ID: <1f06c5c65fcf00d45ce93c97e1434f70626997fa.camel@HansenPartnership.com>
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
Date: Fri, 17 Jul 2026 14:26:42 -0400
In-Reply-To: <DK10YP78VVQO.7BFETGMA9P4F@amazon.com>
References: <20260608144252.351443-1-joro@8bytes.org>
	 <20260608144252.351443-36-joro@8bytes.org>
	 <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com>
	 <aib8n5lO6HKbLC4Y@8bytes.org>
	 <CABgObfbUsDeStnZF-7oyR-W-Bvd4qTMoeUwGizgn10UTdKtZ2A@mail.gmail.com>
	 <aigE2EvJyZlYDz0V@8bytes.org> <DK0W6G329B6W.2KGT7FAVSKNYS@amazon.com>
	 <976f1a8316438d5b7c2f446a0369dcda3289cc92.camel@HansenPartnership.com>
	 <DK10YP78VVQO.7BFETGMA9P4F@amazon.com>
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

On Fri, 2026-07-17 at 17:33 +0000, Saenz Julienne, Nicolas wrote:
> On Fri Jul 17, 2026 at 5:56 PM CEST, James Bottomley wrote:
[...]
> > However, from a quick skim, the main thing is that you used
> > multiple KVM structures to manage the planes which means each plane
> > naturally gets its own address space.=C2=A0 In the current planes model
> > so far there's only one address space (or two if you have SMM).=C2=A0
> > SNP doesn't need anything above this because the VMPL protection is
> > naturally managed inside the guest (so not really visible to the
> > host) but a VTL implementation will.=C2=A0 So I think the big question
> > becomes how are we going to achieve address space separation for
> > planes?=C2=A0 It's tempting to say simply one address space per plane
> > and make SMM its own plane with different switching but it's an
> > awful lot of overhead especially as most VMs won't even use planes,
> > so it looks like there has to be a more opportunistic model for
> > planes address spaces.
>=20
> While adress spaces are per VM, KVM memory attributes are per plane.
> It should be enough to implement VSM's memory protections as well as
> the enclaves design you mentioned. We have a series in-flux
> implementing RWX memory attributes [1].

We might get this to work if we're careful.  It just means when two
planes agree on chunks of memory to seal and share it's helpful if
they're guest physically contiguous.

> The only thing that's not feasible "naturally" with attributes are
> memory overlays or any situation where we'd need to change the
> backing memory of a guest physical address range just for a single
> plane. From a VSM perspective it's fine. The only use-case from a VSM
> perspective are memory overlays (and those, from my experience, are
> useless). I don't know that's a deal-breaker the mutually distrusting
> model.

I don't think so.  I don't see it as a problem that the guest physical
memory map looks the same to every plane even if the page protections
might be different.  This is slightly different from SMM where the smm
memblock is missing from the guest map, so it might be the case that we
don't need different address spaces to cope with this.

Regards,

James
