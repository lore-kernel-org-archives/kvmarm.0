Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4FA281525;
	Thu,  9 Apr 2026 16:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775751072; cv=none; b=DuXYIjyIolg6ZQGnljoDpaCZaazevcUVmx3Ka9njLB3CQ7Hp5ziLpgUusRrrw2nJ58FpERT9Hm5epHU8tY5xoykN84EhG6/c1O2VJaFOh+sugSunDqXLlXv/PxHMzgJfMXWDaGeOWWg7gg4ead9aMVLemuUShIT9d93RqVuNOPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775751072; c=relaxed/simple;
	bh=I+KV0QnGckaExfkug9cCU4y3P+vD9VBLgvWzicrI2fY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u5ETaAu9wMn9h/rvLgtfVdfALJu+hJWWU9kZnJgjM35JDJoPQoOIzBunE+ld8uDNLAqTw0075ov5NsPCrkbACkGRJOLW/dsqBiOR2OvlnwL2JvgwuUKrsVD8+vBnLNIj5ygUr3EiD/nI4xQCQlYjmLQvRaWkfic4ng5juAhx3r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gus/ft4u; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gus/ft4u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I+KV0QnGckaExfkug9cCU4y3P+vD9VBLgvWzicrI2fY=; b=gus/ft4uJhNae7GDB8IPdbYyYr
	h+XyhrewJfdC/FeiJc2geS2FPJHLpobAYO+3zaLsFBJ1DvFBQu6bdg1SqlmHWK3Y3T5iy3eDExtnp
	VvTQgWEL9asM9EJ4VcTPPohtxaxfZpbiaCehQ3BHBIWdb03tKN7BvEXKKTxpxG4tkrV1fIjO+GOfo
	PrAPueyGonJp1D+BN6lh2CaBAr/t6bYmCAnMrCERiQnqYX80r89k3zbdqxuU1xD5QIva6zzP9IDhp
	B8zm49h66VfLmsVABsXegPb12dQTg/M3ZYEhZxClcS6S+qh9C0XVqBkHHEOUs3ev7+cZOO904fgmn
	4nqheNuw==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAry6-0000000C5iu-3WWW;
	Thu, 09 Apr 2026 16:10:59 +0000
Message-ID: <7081de47440cfefd1cf0600473cd18ed53d4e052.camel@infradead.org>
Subject: Re: [PATCH v7 7/7] KVM: arm64: Normalize cache configuration
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>
Cc: "Gutierrez Cantu, Bernardo" <bercantu@amazon.de>, 
 alexandru.elisei@arm.com, alyssa@rosenzweig.io, asahi@lists.linux.dev, 
 broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, 
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, marcan@marcan.st, mathieu.poirier@linaro.org,
  oliver.upton@linux.dev, suzuki.poulose@arm.com, sven@svenpeter.dev, 
 will@kernel.org
Date: Thu, 09 Apr 2026 17:10:58 +0100
In-Reply-To: <86tstk2l4w.wl-maz@kernel.org>
References: <20230112023852.42012-8-akihiko.odaki@daynix.com>
	 <b71910e202ac4a56a87c0e34df13cce058d46a76.camel@infradead.org>
	 <86wlyg2r3i.wl-maz@kernel.org>
	 <254ca48a67779ccf9b9f60e2bb5796a305c03f95.camel@infradead.org>
	 <86tstk2l4w.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-xzkmjBBbsJKO86yZuO/f"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-xzkmjBBbsJKO86yZuO/f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-04-09 at 16:45 +0100, Marc Zyngier wrote:
> On Thu, 09 Apr 2026 15:51:59 +0100, David Woodhouse <dwmw2@infradead.org>=
 wrote:
> > On Thu, 2026-04-09 at 14:36 +0100, Marc Zyngier wrote:
>=20
> > > We have never guaranteed host downgrade. It almost never works.
> >
> > Huh? Host downgrade absolutely *does* work; KVM on Arm isn't a toy.
> > We'd never be able to ship a new kernel if we didn't know we could roll
> > it *back* if we needed to.
>=20
> You have clearly been lucky so far, because I'd never such claim.

It's not luck. We do a *lot* of testing, both within the guest checking
that what it sees is identical between old and new environments, and
repeated live upgrade/downgrade cycles between versions as well as
migration back and forth, and hibernate/resume from one to the other.

> >=20
> > I *know* that you know perfectly well that we actively test host
> > downgrades prior to every rollout of a new kernel. So I'm a little
> > confused about what you're trying to say here, Marc.
>=20
> I said exactly this: we make no effort to ensure that a guest started
> on a version of the kernel can be migrated to an older version -- the
> state space might be different.

You said "it almost never works". If that were the case, then I would
suggest that KVM on arm64 would be entirely unsuitable as a production
platform for virtual hosting. But thankfully it isn't my experience at
all.

Sure, we've occasionally found breakage, such as this commit and the
vGIC 'IMP_REV_1' thing being discussed in a separate thread, but those
are the exceptions rather than the norm.

(And yes, we need to do better than just reverting the offending
commits when we find them, and fix the issues properly upstream. Which
is what I'm doing now, belatedly).

> >=20
> > Now that the values are writable, but userspace can't easily see *what*
> > they would have been in the previous kernel. So having the capability
> > to ask KVM to set them to those values seems like it might be useful.
>=20
> Well, it's only a patch away.

Indeed so. When I asked what I was missing, I was *kind* of hoping
someone would tell me I'm wrong and that I can get the original values
from userspace either through sysfs or some other means, but in the
absence of that:
https://lore.kernel.org/lkml/7fb7b823c68e04321eb532a5b8ae21a818d4926d.camel=
@infradead.org/

(Lore is being insanely slow today but it *will* be there, and the
marc.info first alternative it offers does already have the message).

--=-xzkmjBBbsJKO86yZuO/f
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDQwOTE2MTA1
OFowLwYJKoZIhvcNAQkEMSIEIAo8n/412xEqESgUX76rLyr6HbWhdjGMqJh6gciAgh4MMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAfO14zXPuxTir
wVC4+Qi9ZZGnbnq+aDP1fNUlv2Tlzii2f5e3WgrKdGMLpXdSQYT07KtuIbr2LOIs+tcPaoTVW5Bt
wzTFu2TCE8/S0d/4LC58AT8JBgGyXhVkc+b4N28wZHZLQWcYIaUjygFIxIREKP+yrlsI7J5NT3vH
DDNLpcbBFueVrXxjbdGYV2X2Am+AqQa59X94WfquA/ueol8w8xhT9HTc4ao2f0BVylQhqIjDjT/C
ohZ/9BVvv7g3Jq5x33CchDo1OKVly9NY168o7cphjpye/hxAGpy8mquLP2L0/0HiYIzK2K8vmQDf
E/d6X4MYtwcJ4BZ04UFGVR5S+HDe4xaZgafRCT8lr2AvUwXYnfSUIv1l70Hgc6bF4n0hNrezoVc9
34uezSpBlfdir0beGhPJa+TUOnbsZ9+0lMd5DtPOMDA6O2IyhGVcxVVsrFtUAth1ruHQ5mCa5gxJ
gW6+7TT7Ej1FJVeyFsvU0yC7wVT0AYaT13HOuXgm6gKaxwr6u/Sks5HKag/MBWQ+9rHX9FSghKvO
yIU83jSmaHoKe0UP2ipwhvsmYRgTSkjcPmjCBrqSxjNiOuZuyZymzeZ4MggrIOkNEKY/EYmQ9K2s
m9qlHrg9mU5pMnO67Brnmmb4YDfrwthkV5IXqyilrc0nwwLdXDkY1BsAZqlnTxgAAAAAAAA=


--=-xzkmjBBbsJKO86yZuO/f--
