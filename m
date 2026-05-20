Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A9F332EBD;
	Wed, 20 May 2026 18:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301803; cv=none; b=OchB0hKW5R3zQOngNefTdeZDwlumx5qKv6+VrZ6v7awxsq8fY6h+cCSJDOk6v6G7pPJzQcp/EZ+VMJhq31h0rZvjb/w5aygKGJSDRfPRB/AHKlBN3S6GsFixNDRlHrD84pbPZSKmHgi9RKCwze/1dLk7PiNvPvjKTjC8C3FuKE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301803; c=relaxed/simple;
	bh=w9Ikq54kyZZocqmozWL/YZIYuqcADz6X/bu5InIvuAA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HKjonKxJbK0Njq3k4JUseB9Xv2hl8G16mZxnK4MXEL77RJvG4DVlcnrapeXhVY9RBpw31c838F5fIHE5Oq9oveRM/6gPf8OCiCcMLTWezn9TJJl2jGXWmSak/B0UTx51Guiw45NJeFXrGFBXcLDNmbgPn6QDHxkPgqkZ1hifTFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ny8eIzPz; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ny8eIzPz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w9Ikq54kyZZocqmozWL/YZIYuqcADz6X/bu5InIvuAA=; b=ny8eIzPzOV0oK6bJ6yx4O5Z29r
	RmhEbXuORgsPdjCGa2pxr1NOKGaKvptiBzlwFWsflGtZtzhou+s4OaGi1zbV/dQD/vI9RJOPK9zi0
	60hga+HpYUv1QjvpznsRBULjZtbWOT7BFWeeGOMMh4+e1JfgUxm/ZH6hBPjpG4TgsALAQrYQ08Fjp
	A6Osl3KFWx332Xk24jV8Tz8k9FWmwLK2aE7hAPZTMawEnNNYTKdV0cG5aoHOUSWk4hmfNaBAMQmAR
	gnnzUCl/9Fln4u0dl2tZG1RRIRJfqevUmcxBRhhtW/pPvj6YAT4e+0mWNWu164OZo01UAgNNemPHK
	hxT58iyw==;
Received: from 54-240-197-235.amazon.com ([54.240.197.235] helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPlfz-00000007TDN-0U1h;
	Wed, 20 May 2026 18:29:51 +0000
Message-ID: <849307f7dcc7fd408321ce9be6d405e642014117.camel@infradead.org>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible
 compatibility expectations
From: David Woodhouse <dwmw2@infradead.org>
To: Oliver Upton <oupton@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Will
 Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  kvm <kvm@vger.kernel.org>, Linux Doc Mailing
 List <linux-doc@vger.kernel.org>, "Kernel Mailing List, Linux"
 <linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Jim Mattson <jmattson@google.com>, Joey Gouly <joey.gouly@arm.com>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Raghavendra Rao Ananta
 <rananta@google.com>, Eric Auger <eric.auger@redhat.com>, Kees Cook
 <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>,  Nathan Chancellor
 <nathan@kernel.org>, linux-arm-kernel
 <linux-arm-kernel@lists.infradead.org>,  kvmarm@lists.linux.dev,
 linux-kselftest <linux-kselftest@vger.kernel.org>
Date: Wed, 20 May 2026 19:29:49 +0100
In-Reply-To: <ag3zr7-11FO3k-Wv@kernel.org>
References: <cf429f2082e863571595f74d1d3dedc3e6a82964.camel@infradead.org>
	 <CABgObfacAYexR25SMi1kSZMRnHx3EDGj8=E84V1DumER66ibnQ@mail.gmail.com>
	 <86qzn7wp3y.wl-maz@kernel.org>
	 <593a782c50f3c8656e13b36dfb975a67d43a908e.camel@infradead.org>
	 <CABgObfbS-z3OphDna5W_JQPvw+OK=yXJurVMHp1ANZ5uGEgVhQ@mail.gmail.com>
	 <9d0429ddbe4d8c6993e74237c4395697f80092d6.camel@infradead.org>
	 <agzR2kaJsNa8X9lF@kernel.org>
	 <1243d375846c4f4e20c229a6f09300126188fc8b.camel@infradead.org>
	 <agzq5kwzuJvd7Mh5@kernel.org>
	 <add71b6f61edc6357e1fddad83273b2cba697d10.camel@infradead.org>
	 <ag3zr7-11FO3k-Wv@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-rM3SP4T0Vb419/7oTOIv"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-rM3SP4T0Vb419/7oTOIv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-05-20 at 10:47 -0700, Oliver Upton wrote:
> On Wed, May 20, 2026 at 12:33:52AM +0100, David Woodhouse wrote:
> > On Tue, 2026-05-19 at 15:57 -0700, Oliver Upton wrote:
> > > What ifs and maybes do not meet the bar, in my opinion, for preservin=
g
> > > bug emulation in KVM. Of course there could be a little flexibility w=
ith
> > > that but we need to have some way of discriminating between bug fixes
> > > and genuine guest expectations around the behavior of virtual hardwar=
e.
> >=20
> > I believe you have this completely backwards.
>=20
> No, I really don't.
>=20
> Leaving every bugfix that could _possibly_ have a guest-visible impact
> subject to drive-by scrutiny many years after the dust has settled is
> not an acceptable working dynamic. Especially since it would appear
> that the rest of the ecosystem has long since moved on from this
> particular issue.

That's reductio ad absurdum.

I can continue to work around this one internally, sure.

But I'm also concerned about the general case because not only did you
refuse it, but you *also* said that this change in guest-visible
behaviour "should've happened without a change to the revision number".

Which seems to indicate that not only are you being randomly
obstructive about a one-line fix, you *also* don't actually understand
the general concept of what is expected of KVM, which this
Documentation patch is intending to clarify.

It was *right* to bump the IIDR from 1 to 2 when this guest visible
behaviour was changed. The only problem was not letting userspace
select the old revision. I'm really concerned that we now appear to
have a regression of understanding of even the part we previously *did*
get right.

> If this matters to you so deeply then please, be part of the solution
> instead. You may find that reviewing patches leads to better outcomes
> than getting belligerent with the arm64 folks every time you guys
> decide to rebase your kernel. Hell, hypotheticals actually have a lot
> more weight in the context of a review. And if your testing is extensive
> enough to catch these sort of subtleties, don't you think it's better
> done against mainline?

Yes. Definitely. That's why my series with the fixes is more *test*
than actual fix, giving a nice simple framework for any such changes in
future. It checks that GICR_CTLR_IR|GICR_CTLR_CES are visible only with
IIDR.rev=3D3 for example.

And we're making progress on the amount of downstream crap, but it
doesn't help when we seem to have an impedance mismatch on the very
question of what it means to support customers on KVM at scale. This
thread is not exactly encouraging my engineers to poke their heads
above the parapet.

> Maybe it's just me but I am left feeling disappointed that we all
> haven't found a productive way of working together. I've tried to bridge
> the gap here; we obviously need to do something that at least fixes the
> UAPI breakage. Although apparently we don't even care to meet that low
> of bar.
>=20
> > A stable and mature platform doesn't get to play in its ivory tower and
> > randomly inflict breakage on guests because they "deserve it".
>=20
> Really? Aren't you asking for us to emulate something completely broken
> for you?

No. I'm asking for a path to be able to *fix* it.

As things stand, if I just drop these patches and launch guests on a
new kernel, those guests will see writable IGROUPR registers and may
try to use them. And then if I have to roll *back* a kernel deployment,
those guests may lose interrupts.

The *only* time a guest-visible feature (or bugfix, nobody cares about
the difference outside the ivory tower) can be enabled is when the
kernel deployment is finished and stable and *won't* be rolled back.
And *then* new launches (and reboots) can get it.

And one day, when the last guest which was launched *without* it is
finally rebooted and sees the new model, *then* maybe we no longer need
that one line if() statement to support IIDR version 1.

2018 was basically *yesterday*. And I'm kind of scared that I even have
to explain it.

--=-rM3SP4T0Vb419/7oTOIv
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUyMDE4Mjk0
OVowLwYJKoZIhvcNAQkEMSIEIFW+7T+6iiPD2LAbe3y2ZX+vzE+UM9UwX4ZqelKG8g3pMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAX/tcF36rLZnU
vDg5JmF+f32E/QtpW8faTuvxgIDe3js8ftVO4+U0n5zmXM4mjqaeZQsuTWA2+7aABf0Ab8PQ/jwb
syiNDbfjSkPM4lWedZbaPq1fs9/k0CHCYK1PafmDsjuLx6JUGz6rK7iCapPXWV9KOGIh8lCKX/ZB
iI8YkrNttFYp2IbQuFF+WIyg9+VWOwEkzegGPpGvUI6toAjEkVmEMbAe4WjUqniw6EsrJYXC/KQh
nj2OWgJWKcV1/4gc4PXQPtaEPglBKczlL8JN0hXlERgzRHjeiQpa84MzlDMao2JE55ce0imFGKqO
UnxZUze8ZxaOkzMk/SdMY4WzNxahKOz3pjT+uM0PglZlWt+kk6rClEdLnO10RgNm9FXiBSoOzODF
gmzGTIrl9TuPJbK3ZzOzBbZLnUAPOKfM9rhujmOqwwsgIYxXbW4tc6JyXTMIVQClG3eWSYvZQoB8
c+hdFRoQ2bZIOacWZ8ZfibwIQ54vQM4tyXvMkowHTFsBauBF1Jqlp6iYd/9YFIIJY3FdbZdjt4Nz
2A8ZodyDHZizyDfI6OZtxXdbWZgt4nOJSTe3bqRMgxlm60p5goo6ftFAEXO1wUa70U8pshjJWDw6
HFixchLud6w6LHBOBbAelcMFNhzCC5e1F/+EclvOuDrqZGTCKazZwak9xV569jQAAAAAAAA=


--=-rM3SP4T0Vb419/7oTOIv--
