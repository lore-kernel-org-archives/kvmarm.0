Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA15917BCA;
	Thu,  9 Apr 2026 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775746331; cv=none; b=swy4ToQGpHC6jgYB1X9/8DF3oYaMS64n3rTZQVCLMM/K/+/DGnG+X8EpPG6TgsrPU5JKts4ZpwBoAd4nw+PEGaZNtR56FNgCEJJiDYD9p8HjxmOqV/crYrazlvgMxgKfh5TNLL3Lz9Vjjj+mgMWY8QCx6kch8VKwjWrZZa86HpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775746331; c=relaxed/simple;
	bh=hNFRjrU42Z6SYVO+w/DOnUGPmFLCpSMQlxr2/OLaq14=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FUysoPE5AazCTTbG01iwzqNVmtC19u7GRwI5Lunr+xZu2Rjp56ShY+rCQx1kbSIxuPeAVWe10F+FYfqYxEKOtnHyMu0BMR7+OTNwYgFiaFnVYvQHM+D0O1VmL5ksjZbMFJ7rd/MijRv1YmfO/Kn3EdrDTfQWgbi0HFQHXO9z3pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DHMRrDUS; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DHMRrDUS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hNFRjrU42Z6SYVO+w/DOnUGPmFLCpSMQlxr2/OLaq14=; b=DHMRrDUS+PFfnPeJelsWuX1O4k
	Io4bggwcxcvyrMwvEB/5TpkaVw3FXdHZs7VNG2KlwHaFTQXQu9bV1cv41Fzd0+MunOkwVGAlOzdAO
	9wLvSBY8TigOUSCNC5n+5DtWzbcmElytlOtzzvCitNrRDEYDKp6JwvtSy8646oyxEyM1S/E6tDYu2
	vT4EfEoeIiMMwZpYlbyyLhN1CW/AjLU0kAXQfTqTYwZqnFppFD3p5HQYbsmEzLpUqyhEUA5RjWtl9
	w1zSquJp0m9zBd+mYXUOnUhR7v5HKilFPZfPVigeCzzvPIXC/CO8LRfEVtFaafzudzvUribjQ0Efo
	waYVLsiA==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAqjf-0000000BvFm-3wLU;
	Thu, 09 Apr 2026 14:52:00 +0000
Message-ID: <254ca48a67779ccf9b9f60e2bb5796a305c03f95.camel@infradead.org>
Subject: Re: [PATCH v7 7/7] KVM: arm64: Normalize cache configuration
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>
Cc: akihiko.odaki@daynix.com, "Gutierrez Cantu, Bernardo"
 <bercantu@amazon.de>,  alexandru.elisei@arm.com, alyssa@rosenzweig.io,
 asahi@lists.linux.dev,  broonie@kernel.org, catalin.marinas@arm.com,
 james.morse@arm.com,  kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 marcan@marcan.st, mathieu.poirier@linaro.org, oliver.upton@linux.dev, 
 suzuki.poulose@arm.com, sven@svenpeter.dev, will@kernel.org
Date: Thu, 09 Apr 2026 15:51:59 +0100
In-Reply-To: <86wlyg2r3i.wl-maz@kernel.org>
References: <20230112023852.42012-8-akihiko.odaki@daynix.com>
	 <b71910e202ac4a56a87c0e34df13cce058d46a76.camel@infradead.org>
	 <86wlyg2r3i.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-kWqLsqUWPHxL54CrnK2x"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-kWqLsqUWPHxL54CrnK2x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-04-09 at 14:36 +0100, Marc Zyngier wrote:
> On Thu, 09 Apr 2026 13:25:24 +0100,
> David Woodhouse <dwmw2@infradead.org> wrote:
> >=20
> > On Thu, 12 Jan 2023 at 11:38:52 +0900, Akihiko Odaki wrote:
> > > Before this change, the cache configuration of the physical CPU was
> > > exposed to vcpus. This is problematic because the cache configuration=
 a
> > > vcpu sees varies when it migrates between vcpus with different cache
> > > configurations.
> > >=20
> > > Fabricate cache configuration from the sanitized value, which holds t=
he
> > > CTR_EL0 value the userspace sees regardless of which physical CPU it
> > > resides on.
> > >=20
> > > CLIDR_EL1 and CCSIDR_EL1 are now writable from the userspace so that
> > > the VMM can restore the values saved with the old kernel.
> >=20
> > (commit 7af0c2534f4c5)
> >=20
> > How does the VMM set the values that the old kernel would have set?
>=20
> By reading them at the source?

Yes, but the VMM in EL0 *can't* read the source, can it?

> > Let's say we're deploying a kernel with this change for the first time,
> > and we need to ensure that we provide a consistent environment to
> > guests, which can be live migrated back to an older host.
>=20
> We have never guaranteed host downgrade. It almost never works.

Huh? Host downgrade absolutely *does* work; KVM on Arm isn't a toy.
We'd never be able to ship a new kernel if we didn't know we could roll
it *back* if we needed to.

I *know* that you know perfectly well that we actively test host
downgrades prior to every rollout of a new kernel. So I'm a little
confused about what you're trying to say here, Marc.

> > So for new launches, we need to provide the values that the old kernel
> > *would* have provided to the guest. A new launch isn't a migration;
> > there are no "values saved with the old kernel".
>=20
> And you can provide these values.

If I know them, sure. But I don't, because:

> > Userspace can't read the CLIDR_EL1 and CCSIDR_EL1 registers directly,
> > and AFAICT not everything we need to reconstitute them is in sysfs. How
> > is this supposed to work?
> >=20
> > Shouldn't this change have been made as a capability that the VMM can
> > explicitly opt in or out of? Environments that don't do cross-CPU
> > migration absolutely don't care about, and actively don't *want*, the
> > sanitisation that this commit inflicted on us, surely?
>=20
> I don't think a capability buys you anything. You want to expose
> something to the guest? Make it so. You are in the favourable
> situation to completely own the HW and the VMM.

Now that the values are writable, but userspace can't easily see *what*
they would have been in the previous kernel. So having the capability
to ask KVM to set them to those values seems like it might be useful.

> > Am I missing something?
>=20
> That you had over 3 years to voice your concern, and did nothing?

I was looking more for technical input about how I might determine the
original values to retain compatibility... but yes, I have given
feedback that merely *reverting* the offending commit in previous
kernel upgrades without actually doing anything to fix it properly
wasn't the best choice.

--=-kWqLsqUWPHxL54CrnK2x
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDQwOTE0NTE1
OVowLwYJKoZIhvcNAQkEMSIEICfU2Geu2XGCTx/cKSwnWyJJo2hCiDITR0d7+bcTCriAMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIATzDJGkz/oTvi
TvCTrk8XVSG7hf4As0zDs+oszp6fNeOgePSVMkqVxxTBeyxO3lQE+Cfnc9QE01Lo5Nkzpllol502
3sBamp3a776D2mCfhgcNs2uYCjV8ISH90cXyRJswFErafSdquEDMOh/9Zx1pM4VCFTSIcemRPOgi
2+Ban73HHxf7xNkE/a+hxMCPbOP0MGItL8jtohy5GDKcO/nQAOi5O766Wd4ViT3NgMheGaJbGTmD
Wjj3QiOLBZGMmpmBMGzDEuOuW+GOfZGdIT3DUuLaGncL9n+rSf58YyqUA8U4DRrTzSFJRLCyVUPh
EMcZQCF0xuu1yGy9xW1TQQgSDke8O3fZoG1+RRqlpkGHJju8nUKXPYL7WShZEYn63T6cE5rRlmj5
xb9qy4m+7TKqO0jMjW7qK7vfKm5h8egoipc6r1nnf9XFC0kQU9sW4RGXaqJdbuvbBaL4VDt8IUbY
I6WGS5/OfAKGpwlmPe3fdCgSWBvt2PnnAGdy/vbQ7v803kGa6Z6mvk9+OvTsGB9wZV9mNcFAUAEv
zhZFB1hHmv7ZmfyvQnHb/hMMjCIK7QwqWKS6ZtXwOHdW3HzaxSaDbQULMT1902izuypRIZlIGiMT
GCo1bdyrgRhPVKO4BXP+d2o+9cscRqR2P+KWt0cfqCGBBiMrg1E283dqWvJgCG4AAAAAAAA=


--=-kWqLsqUWPHxL54CrnK2x--
