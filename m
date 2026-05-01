Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F64436607D;
	Fri,  1 May 2026 08:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777625800; cv=none; b=TXYFO7Xc2cZUuHNweMi4bCDOa2WddXG2eOJ3KmInWiqyMrb8G8zuR9hDpmF4kyPuv4xOWEFTg+2ca6OVaCUnx4btb/2b1KOXHMdlHrN5x7sJ1NylmRL5qR17F+07SnJ0XpJpghBtrkti/o/LGDWdke/j5ujPSh1e52LUlChth6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777625800; c=relaxed/simple;
	bh=ioCO1TCIHurAVCNV+U1Ag+1WEIpQzKhEiX18+eECsNw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bOj4/qnyNiVdyB1DwC1cFyc8s2mt+TWXCoVAnBA0HO+8fgG3Dmor9jCkUw33oPoWe8LNDOfTsqxb1GXDrr9GwReusQpvzFhfzsr3j8wa2ZQKWbfjQyBRdQw+IAXhuar79Z0qgFhHi2GhqzT0/0+lZi8ZqNsRvoxEXO1yLoljnAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kEhgMPPe; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kEhgMPPe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ioCO1TCIHurAVCNV+U1Ag+1WEIpQzKhEiX18+eECsNw=; b=kEhgMPPeXBOexo7Y+5mwBiTznO
	Q8LfN8HrciDeXvmhjnNOC7NZ4O77yFiEXhaIa7H+fzpr7dFyFOQM1oBqnBImnt4AOmkwNuyFzGAhU
	luaczhU5EhmrvVSJlhq72yn7sIPQV9+yu5/C7ajWr9P1mGY+8v5KVJoxIaSrofCcg4oYe/vC0DFl3
	CYBC2SCaNVIhLRVZdWZdw8HQn0Rvl/JsLe6R3MIGhHVfGi3om/twkQrRx5L9e1KhuqRB6LarnCNYH
	2U+G4rb49MHXjE6s5NaQ/0YPztACIGkQkXFDNCNWvKkU/7tBu8z3CUGT0nxb8mbdJE1YQ1a17HRwK
	wRb6GdwA==;
Received: from [172.31.31.148] (helo=u09cd745991455d.ant.amazon.com)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIjfd-00000008kG2-0eQL;
	Fri, 01 May 2026 08:56:26 +0000
Message-ID: <718a82870c8f3c913791f12a993e11b2d26d08d9.camel@infradead.org>
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>, Pasha Tatashin
	 <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: rppt@kernel.org, graf@amazon.com, pratyush@kernel.org,
 seanjc@google.com,  maz@kernel.org, oupton@kernel.org,
 alex.williamson@redhat.com,  kevin.tian@intel.com, rientjes@google.com,
 Tycho.Andersen@amd.com,  anthony.yznaga@oracle.com,
 baolu.lu@linux.intel.com, david@kernel.org,  dmatlack@google.com,
 mheyne@amazon.de, jgowans@amazon.com, jgg@nvidia.com, 
 pankaj.gupta.linux@gmail.com, kpraveen.lkml@gmail.com, vipinsh@google.com, 
 vannapurve@google.com, corbet@lwn.net, tglx@kernel.org, mingo@redhat.com, 
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
 roman.gushchin@linux.dev, akpm@linux-foundation.org, pjt@google.com
Date: Fri, 01 May 2026 09:56:25 +0100
In-Reply-To: <3ff53353-3842-4a63-80a1-90a60d09fe02@redhat.com>
References: <afEwWZksU0Fw61oT@plex>
	 <0a71472c-b397-4699-a518-61faffcf4ab2@redhat.com>
	 <c004f333ed4f7dedae1383f22d43b009cd83837e.camel@infradead.org>
	 <3ff53353-3842-4a63-80a1-90a60d09fe02@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-sFyvC01RhMyOh3+boK9j"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-sFyvC01RhMyOh3+boK9j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-05-01 at 05:32 +0200, Paolo Bonzini wrote:
> On 4/30/26 17:27, David Woodhouse wrote:
> > On Thu, 2026-04-30 at 15:28 +0200, Paolo Bonzini wrote:
> > > I even wonder if, for long term simplicity, the interface for
> > > host->caretaker should be just for the caretaker to swallow the host
> > > into non-root mode, again as in Arm nVHE.
> >=20
> > There's a lot of merit in that approach.
> >=20
> > I talked about wanting to use this 'caretaker' for secret hiding.=C2=A0=
 But
> > why have *voluntary* secret hiding with the kernel hiding things from
> > its own address space, when you have have *mandatory* secret hiding
> > with something running in EL2, like pKVM.
>=20
> Well, other than because it's a lot of work? :)

If we avoided those things then we've never have any fun!

And in a week where there seems to be a new user-to-root exploit posted
every day, the 'deprivilege the VMM and assume the guest has owned it'
security model is looking rather scary. So the additional defence in
depth of knowing that even *root* can't get the kernel to access other
guests' memory might be the only thing that lets you sleep at night :)

Yes, it's a lot of work. But I think we've reached the point where
mandatory secret hiding is... well... mandatory.

> > The *userspace* ABI considerations are all about how you make a vCPU
> > that runs asynchronously (should it conceptually just be an async
> > KVM_RUN call, which allows the vCPU to run in a kernel thread up to the
> > point of kexec? Why is it fundamentally tied to kexec at all?).
>=20
> It's not tied to kexec.=C2=A0 kexec is just forcing a handoff + forcing a=
n
> update.
>=20
> The big difference is that:
>=20
> 1) if you don't tie it to kexec, a detached vCPU thread is a struct=20
> vhost_task and a blocking vmexit schedules out the thread; while during=
=20
> kexec you have s/kthread/pCPU/ and halting the CPU instead of scheduling=
=20
> it out.

For now maybe. But "how does the caretaker do scheduling" is on
definitely the list of future problems, for any environment where a
physical host with N pCPUs is hosting >=3D N vCPUs.

(In the case of a true mandatory-secret-hiding caretaker at EL2, the
scheduling part *could* be done by the residual purgatory-caretaker-
thing at EL1 that all the secondary CPUs go to instead of being turned
off. It would just be calling into EL2 to run the actual vCPUs. Thus
leaving the EL2 code just to do its *one* job, which has the added
benefit that the automated reasoning people put the knives down and no
longer have that look in their eyes that they got when they thought you
wanted to put a scheduler in their formally-proven EL2 code...)

> 2) if you don't tie it to kexec, address space isolation is the only=20
> real reason for the complication of treating the caretaker as a separate=
=20
> bare metal program.=C2=A0 OTOH maybe that's a feature - you could do:
>=20
> - ioctl(KVM_RUN_ASYNC)
>=20
> - then vmfd/vcpufd handoff to a new mm on top

This much gives you a seamless upgrade of the userspace VMM without
having to play fd-handover tricks. The old VMM detaches, the new one
attaches. If you're quick, and the guests aren't doing much "admin"
work but only passing traffic through passthrough PCI devices, the
guests might not experience any non-negligible steal time at all.

> - then address space isolation on top

Even voluntary secret hiding lets you sleep at night when the next
Retbleed happens.

> - then kexec (de)serialization on top

... and this one is the holy grail.

So yes, that's exactly the kind of thing I was thinking, rather than
trying to boil the ocean. There are sensible milestones along the way
which give practical benefits.

But my point was *also* about understanding the actual userspace
interface for this, even if we were to just focus on the live update
and do it all in one amphetamine-and-tokens-fueled epic. What does it
even look like, from the VMM point of view?=C2=A0How does the new VMM under
the new kernel 'reattach' to the existing vCPUs?

I think we need the userspace API concepts for 'detach' and 'attach',
including the permissions model for reattach, and we might as well
implement and test them without the kexec in the middle to start with.

> > I'd love to start without kexec in the picture at all. Just show me the
> > KVM API for starting a *confidential* guest (pKVM, SEV-SNP, whatever),
> > leaving it running, completely stopping the VMM and then starting a new
> > VMM to pick up from where it left off.
>=20
> Why confidential?

Mostly so that confidential VMs aren't an *afterthought*, and the
design of the detach/attach userspace ABI gets them right from the
start.

--=-sFyvC01RhMyOh3+boK9j
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUwMTA4NTYy
NVowLwYJKoZIhvcNAQkEMSIEII5NFTIwOYgMNBQlBlgPOzaWECUuLzzwItLBZqgfRq/AMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAVeROddN9z3Oy
G3nmGGdyNd5AGy+uQmYUIxVsBmdByuQmk21ERmEU8akkOpBdHAQntRNo2CLLhc3XyqlF5+DJVOht
wcW++lbsUkpJztgXcgurbSvpuNmvSmsK23wJ97BWqbw7DIb5CTEXwABq0bxA3bJNkAgT4ZhYsUR2
QRo1fSqAfYmfQOhcu1LhZFhdS5nzXA0atjxPQiada4IJMU3ubTHpVH5Irm2i52V8gCS7QkDg8Ttz
EhmVSLz6561Kb5cFe3tubEv4IMm5SuaovgWunMD0rZbFzsgtpjj125Am5i2XSBe5CsSHG2wjugK4
XWyg4LZ1ZqWysUyY5ITldVR9a4RR9oSgQlPIN9B1Nh9pRWuCzkq87XnhN8HMWQ9aeTrZ5YtnMV67
DDh/RAUXNOqUKXJYN+6GRvBiVUEgeh7eBOAUalTab6ihAGI6QjMnM9t3zeexssx+iGktjNbvb+20
UQ1HubSiMBs/AjhD7bwpFmwzg/5pcQMKYsBdNSNQqSGIEauGMER1qFzhvV6OIsY4NtbSTD6xmvED
gHZtQH91CTYSQ+gTz82Vozp2KOA622wdHCzDcfqHM9kwYBhehdZiEONrhCtQ8pgFUEwXU4gCsz+P
FGq75I68qqPwK1ZdIExOrNOb7KiTJOGRxsdxQ1AmrTPEd9qPnYb40Eco/mR8K0wAAAAAAAA=


--=-sFyvC01RhMyOh3+boK9j--
