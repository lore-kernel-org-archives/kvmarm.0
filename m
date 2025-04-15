Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463EA28B4F1
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 09:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744710288; cv=none; b=MqRk4dac3xLo1gWOijwZ+fxiKn/EQmXYsks/rxBOU620Wwm7KvSJcuDO54Oy4q1n2r7z6WcNjjh8op6kJYhgO4hz6uilhyVEH7hUGIJy8wqrz9Tlm9deT6nsFL6cT1Am7C4rdZUMxQtsO2s6KyPFH92aWj6z1Sd1O9IVduPtcJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744710288; c=relaxed/simple;
	bh=0VKOmYDW4CnICKMLQOGWg3GqeC1BFteuctz72BlkqQ8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QF/zS8Gd0RKWAZZVAoWr9b/uoEuXto9qp2GaTWbYwUWwov02yHb7tbcsrjdxAMCyxEaCwXYYiPKT733DjZXyNa+tBhXoEHp1f/hu7zEdWecHxtUNa2aeaMEuV8cXviDYw8pDBgbWm1J8VFSPdXmv+XY48TYLSXNSvyLCMEPiCbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e6djeZMj; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e6djeZMj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0VKOmYDW4CnICKMLQOGWg3GqeC1BFteuctz72BlkqQ8=; b=e6djeZMjeHHneEywS/Cj2IrlrJ
	6zhgX94NBuclE00jS5i1zShKoW0jWtzSMe+cte5/92FFNNseAm9tiqTNe1eQ8Dzik/qzLWnFKrwzo
	nLbLEfvTBljA7b6Me9lXyJgpZ2nIwlv+JNsyYwFjOE9D9Qie1kp/h0qPkJc7oEOs/b7JUjAGlfXoL
	HKcR2CuWWd641lanOZaZMmIyrbKjnuBJ0x1AwSW/emjWqJzObin7btUr/CGAvwgVdmC3nURMaUaPK
	5TZN9yUCfaua/r00SLC5GtaosEBnOt/66Ioble9SNFV0RN8ntmg4dv67A2Gs583Q7cXcqhq0d3A11
	/NBgLOQQ==;
Received: from [172.31.31.140] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u4cqO-00000009qZx-0HfK;
	Tue, 15 Apr 2025 09:44:40 +0000
Message-ID: <94fb9d4adb81f824912ee23a296776aa07873354.camel@infradead.org>
Subject: Re: [RFC] ARM vGIC-ITS tables serialization when running protected
 VMs
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>, Ilias Stamatis <ilstam@amazon.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, eric.auger@redhat.com, andre.przywara@arm.com, 
	will@kernel.org, jgrall@amazon.co.uk, ugurus@amazon.co.uk, 
	nh-open-source@amazon.com
Date: Tue, 15 Apr 2025 10:44:39 +0100
In-Reply-To: <867c3llt43.wl-maz@kernel.org>
References: <20250414111244.153528-1-ilstam@amazon.com>
	 <867c3llt43.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-kvekzmVFWW8CtbbTfdnn"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-kvekzmVFWW8CtbbTfdnn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2025-04-15 at 09:35 +0100, Marc Zyngier wrote:
> On Mon, 14 Apr 2025 12:12:43 +0100,
> Ilias Stamatis <ilstam@amazon.com> wrote:
> >=20
> > # The problem
> >=20
> > KVM's ARM Virtual Interrupt Translation Service (ITS) interface support=
s the
> > KVM_DEV_ARM_ITS_SAVE_TABLES and KVM_DEV_ARM_ITS_RESTORE_TABLES operatio=
ns.
> > These operations save and restore a set of tables (Device Tables, Inter=
rupt
> > Translation Tables, Collection Table) to and from guest memory.
> >=20
> > This can be a problem when running a protected VM on top of pKVM or ano=
ther
> > lowvisor since the host kernel (running at EL1) cannot access guest mem=
ory.
> >=20
>=20
> pKVM doesn't allow a guest to be saved/restored, full stop.

Yet. Either it's going to need to learn to support live update, or
it'll remain a toy solution.

> > # Page declassification and why ITTs are special
> >=20
> > The Collection and Device tables are page aligned and their sizes must =
be a
> > multiple of page size. If the lowvisor knows where these tables live, i=
t is
> > possible to "declassify" the corresponding pages and configure the MMU =
such as
> > that the EL1 host can write to guest memory directly.
> >=20
> > The ITTs (Interrupt Translation Tables) are different. They are NOT pag=
e
> > aligned, they are 256 byte aligned and their size is variable. That mea=
ns that
> > the lowvisor can't declassify pages containing ITTs and configure the M=
MU
> > giving the host direct access as above since those pages may contain un=
related
> > data.
>=20
> And it is the responsibility of the guest to make these page aligned
> if it intend to let the hypervisor use them. To sum it up, the ITT
> isn't special at all.

The ITT has nothing to do with virtualization, does it? And despite
this being logically "DMA", I don't believe it's possible to advertise
it as being behind the SMMU, which would have allowed for access
control (and would indeed have meant that the guest would be expected
to grant access to full pages).

What exactly are you suggesting? That the GIC specification should be
changed to require page alignment, or to document that in a
confidential compute setup, the remainder of any page which contains
ITTs will be implicitly made non-confidential and shared with the
hypervisor?

And then the lowvisor would also have to snoop the ITS command queues
to even find out which pages to implicitly allow access to?

> >=20
> > If the lowvisor knows where the ITTs live in guest memory it could inst=
ead
> > perform the guest memory accesses on behalf of the host. I.e. the EL1 h=
ost
> > would attempt to save the ITTs to guest memory like it does today, that=
 would
> > generate a data abort, and then the EL2 lowvisor could perform the copy=
 after
> > validating that the faulty address belongs to an ITT in guest memory.
> >=20
> > One issue with the above is that the ITS save/restore happens at hyperv=
isor
> > live update which is a time sensitive operation and the extra traps (on=
e per
> > interrupt mapping?) can introduce significant additional overhead
> > there.
>=20
> I don't believe this for a second.

You don't believe that every millisecond of live update downtime,
perceived by the guest as unwanted steal time of a hypervisor that's
generally trying to be as quiescent as possible, is an issue?

> >=20
> > Another issue is that it's actually hard for the lowvisor to know where=
 these
> > tables live without trusting the EL1 host which virtualizes the ITS. It=
 is
> > especially hard knowing the locations of the ITTs (compared to
> > Collection/Device tables) because that probably means having to parse t=
he ITS
> > command queue from EL2 which is complex and undesirable.
> >=20
> > # An alternative: Serializing ITTs into a userspace buffer
>=20
> NAK.
>=20
> Share the page-aligned memory with the rest of the hypervisor, and use
> the existing API.

That seems like a bad choice. All this is just using guest memory to
store KVM's state.

Yes, the guest provides a buffer which the virtual hardware *may* use
if it wants, but with no IOMMU or access control defined in the
specification.

It seems like it would be much cleaner just to let KVM pass its state
up to userspace for serialization like we do for all *other* KVM state,
which is what Ilias is proposing.

--=-kvekzmVFWW8CtbbTfdnn
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDQxNTA5NDQz
OVowLwYJKoZIhvcNAQkEMSIEIHqRiyU8I1VVo0QkJFQUraepic4oV4rt4H8WJPUKGYTaMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAIlbRC0zbtGGz
zoHigyN/6QNXQIzyBuUU9wAU8vavFcOZZB9X1FfWmfE95hR3HHwRDLhOOYrE2S+mCLQLUCMXjDip
zYoUo54I3gOenNVM4VtlRRYMlcRLsgwwwHx8oiMnBrhq1VWRFFsoTQGLsU8RizvfRGuQYdpwzcYw
0RNYSbQVdEzT9VyU/AFRFGYThAwi8wE3IRu582wCW9ffteDjrcooWeFtdyEHvDBahTQqmKDFGnWS
mOV1lU8KOzBYqMVTAJQ8iPYQX7Pwj5Qwra5DWWF6ffIUrMksszFRQtSPNhuN5UuiW+e9TVwqIeD/
QIclN/059wwKu9Y8VcX0SILOaKAFTYJWw5Hyr7xN7Nm+mK8MugSmQWNYgd3JfbJzZHQVfZNPAnf0
JPDYeiOobkcKc85wMCYCbWWwDYb5Oh5HAsMrTsW6sYAVkPC6o3/FYPIAV3xynCoIy+GVT3F72Tii
haJqkPde/pb60P9WyXd3Cu3k0nrSq4D9hxbAk58rvjgpUoyWx55hd3QqdpkgJy7a50gRrlvJqU9M
OBlmpIWGnUHfocL0O8RuCFW1eMpIpFNwgacW8tb0EpRKhxWaQw+N3JcSBPH0lJntMArl0Ef46PTT
sk2pYQN7mbiJaOAnetCKcDKFyjg5J2aZHWZ/Unrqjc5ihyFmor0s4RhQoy4PcREAAAAAAAA=


--=-kvekzmVFWW8CtbbTfdnn--
