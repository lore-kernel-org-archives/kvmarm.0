Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586A81B7910;
	Thu,  9 Apr 2026 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775746913; cv=none; b=sDiop27f9LWkus6DXVtuuFRalXGf94/ENAfo0ICKT4YIOBLp5G/X/YSGnPLelAcS2eUBTcsVjm7I6M6PaB/DmbGv9MkZWpWojWn+OAPbQLxnRe4s5A83XZjVuwxpgyKO3qxHZ1OswZVPndAGc8l5DLPb7Ah2mIb0eP7YSA4fEwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775746913; c=relaxed/simple;
	bh=ZAa6f1sQobFR6hiCOCOOW2kkrrVSoF8tuVYfYChI4uk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rq0MrRtbauM8cfqDbrD2Hf53QRNvEXHlCVTHK9X+I2EEqEVFKnoOv/EcDBlfnKFPamMsYBPaBJUt9QcKKlfafsxM794QtnJHbIDDLaUsT30ckNXo6rsTF4QrEbENkjMBUWzVtDtNhIaboeayhA5J24ZCM7YnUfEgPPjHdWIv8QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GiaUcG+P; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GiaUcG+P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZAa6f1sQobFR6hiCOCOOW2kkrrVSoF8tuVYfYChI4uk=; b=GiaUcG+P1TeZQ7TtwUm4e4s2aL
	Phjdl1xlNltVDANdu9MDTDGe9uDtCHctS2ewtBCqMsX8a7kE5tyl/bYNBXPRUYHe0B8sQBIh0ONzO
	E9cZOdyPqTDBHg253ch8pdjXLHe86Ur8Qv2efo3us+S6X0XgtFrxzxHQGQOlzBe/vESQNIz2neVB5
	eiRucQpc6RhIYN4j/nXNoz3wHzdyJE9MMCLvb8cBII4w58f5bz+NxLKqaSpQ6/lJreDj5v78G7Om8
	Pz75SAdfXZM2ztPMzGCaOq/rkPsijAg8XMkrDVaTOf709HkYEqqRKf3d6644lK5opls/DItWwhInt
	fmh8v5jQ==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAqtA-0000000BwB3-20zD;
	Thu, 09 Apr 2026 15:01:48 +0000
Message-ID: <8cca18f332ea4bfb0c9f9d6775b2c1284816dd5f.camel@infradead.org>
Subject: Re: [EXTERNAL] [PATCH 2/3] KVM: arm64: vgic: Allow userspace to set
 IIDR revision 1
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "shuah@kernel.org"
	 <shuah@kernel.org>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
 "joey.gouly@arm.com"
	 <joey.gouly@arm.com>, "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, "catalin.marinas@arm.com"
	 <catalin.marinas@arm.com>, "nathan@kernel.org" <nathan@kernel.org>, 
 "pbonzini@redhat.com"
	 <pbonzini@redhat.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
 "arnd@arndb.de"
	 <arnd@arndb.de>, "kees@kernel.org" <kees@kernel.org>, "will@kernel.org"
	 <will@kernel.org>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
 "oupton@kernel.org"
	 <oupton@kernel.org>, "rananta@google.com" <rananta@google.com>, 
 "linux-arm-kernel@lists.infradead.org"
	 <linux-arm-kernel@lists.infradead.org>, "linux-kselftest@vger.kernel.org"
	 <linux-kselftest@vger.kernel.org>, "eric.auger@redhat.com"
	 <eric.auger@redhat.com>
Date: Thu, 09 Apr 2026 16:01:48 +0100
In-Reply-To: <86v7e02qoq.wl-maz@kernel.org>
References: <20260407210949.2076251-1-dwmw2@infradead.org>
	 <20260407210949.2076251-3-dwmw2@infradead.org>
	 <87wlyhc2g4.wl-maz@kernel.org>
	 <ffe9de5106d999365389c3ab17f357409dac1047.camel@amazon.co.uk>
	 <86v7e02qoq.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-xpT07MiBO99LU65F6dIx"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-xpT07MiBO99LU65F6dIx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-04-09 at 14:45 +0100, Marc Zyngier wrote:
> On Wed, 08 Apr 2026 09:39:15 +0100,
> "Woodhouse, David" <dwmw@amazon.co.uk> wrote:
> >=20
> > What if the guest boots under a new host kernel and finds the group
> > registers are writable, and then is live migrated to an old host kernel
> > on which they are not?
>=20
> That's your problem. KVM/arm64 never supported downgrading.

Again, I don't know why you're saying this. It isn't true, and *can't*
be true if KVM/arm64 is going to be anything more than a toy.

> Not to mention that there is no valid GIC implementation that has RO
> group registers. All you are doing is to inflict a hypervisor bug on
> unsuspecting guests, for no good reason.

It's not about "inflicting a hypervisor bug". It's about preserving the
exact same environment that those millions of guests already *have*
instead of taking the risk of changing things underneath them. And
giving us a *path* to cleanly upgrading for new launches.

> > What about hibernation, if the *boot* kernel in the guest configures
> > the groups, but then transfers control back to the resumed guest kernel
> > which had not?
>=20
> A guest that doesn't configures the groups cannot expect anything to
> work. You'd have the exact same problem on bare-metal.
>=20
> >=20
> > > So what is this *really* fixing?
> >=20
> > I look at that question the other way round.
> >=20
> > KVM has an established procedure for allowing userspace to control
> > guest-visible changes, using the IIDR. First the host kernel which
> > *supports* the change is rolled out, and only then does the VMM start
> > to enable it for new launches.
> >=20
> > Even if we can address the questions above, and even if we can convince
> > ourselves that those are the *only* questions to ask... why not follow
> > the normal, safe, procedure? Especially given that there is already an
> > IIDR value which corresponds to it.
> >=20
> > We don't *have* to YOLO it... and I don't want to :)
>=20
> That's hardly an argument, is it?

Er... yes, yes really it is an argument. I don't want to randomly
inflict a device model change on *running* guests, and when they resume
from hibernation, when I can preserve the existing behaviour.

It's weird enough that you claim that KVM doesn't support downgrading;
now you seem to be claiming that it doesn't support retaining
compatibility when *upgrading* either!

The ability to set IIDR like this was explicitly *designed* for this
purpose, wasn't it? Why on earth would you object to being able to set
it to KVM_VGIC_IMP_REV_1?




--=-xpT07MiBO99LU65F6dIx
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDQwOTE1MDE0
OFowLwYJKoZIhvcNAQkEMSIEIFPy9hHaSOjyZBjVDdJvAzancl+nJCsgXkPlt77PjrP7MGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIANxBRkRj9GMyZ
iN7PzrjoWYUmQosjAB3gEEZL5T6ve3oQ8JDIPdlFMSuAmlmONhoI6MpjfRH+XtAMwvhITrCjYMu5
aEqJoGbMBz82UU0veQFLQPXudGaLmSAWYTNRI86AepMg9Si85Ob4/1Yr6YJBPnI9FRGp0UvrDZwv
qHk/IHDs21/UDF4/+BA5QTQUIhEyu61vFDAYkBpnJY80s3oxbQlrGhpnmyQO5MVtgSmNDFY1tMCx
x9bKil+FTTu9V+dYmF7OQbUUoJtEPhH3PsW6nC9P+EGbsDrIzyDWlsGG8PKJOUhwpVfQo2Shj6+v
UuWt05xXJyx3p9lU/3CiufWeXXfY/yD0yEWyTXsHEKSqLhY1THjpLD/SVTjweSB62+UGUX6O3Avc
Xt/7JtMMrW6ctfvIwaHYzszF+SEaUM0WxJao/yTX0UrEZA4b6h3Px/fG27hiXpJ5gOtm7gGjCFX2
rRLnTz9QHkPZu8w45Wre/kE3NU7cQ0N02v7cB+SCdoB9NgIJtO21znI3cc+FkvkLxVSCELdoe29b
LX2+gwE6e6i1xrtUoHu2/BX1QXTn5BQU8S4MsZ4du0dMNo/H7RGpUh70m/kY6ym6qxQN4meN1Hqa
PPjKMcSddtOLonqrEU/zqm7g3Y6WXhB5eJm+xIfiNA7losuSUblB1c5CWC6tES4AAAAAAAA=


--=-xpT07MiBO99LU65F6dIx--
