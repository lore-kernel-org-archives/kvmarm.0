Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190213;
	b=ytRNvFESx/i17/Vqev/arQLKmdNP9vepm2kj3DAbnht8QPOmHQ+pDCgBvbOiFJ69ZqEP
	 eJZtZAQtndzmloZ+3EoRMt4rr/QWruQz9nM8XGo2GDdZGAgO60A5V7d3tW0AuXWD30DXe
	 p3v1SEoEWV8cotdv909KYPpTs6gwgdMpeGo7tHr80n1XW6vt7ve7LPG8e8KWv1xrRsDea
	 PVilaWE311vOpdYxxSrePuCNiVjvUAHI4iPBkf0v2Aqs+ojcGK4PsAV8uItxomZmkxo77
	 8w1KRbiqzWvYth4evCp0CwENj1nVU13YbqAeCT526YVJj4Rw1c9kj1mSGTyJMJWn//Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190213;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:in-reply-to:references:Content-Type:User-Agent:MIME-Version:
	 X-SRS-Rewrite;
	bh=XA6joGP5vLeK1TouEaq2G5Nj77T00m7V/e6BxV7FEhA=;
	b=Wvaxkc5s2IhyvbS/YVCHS2USDt4qI2fDl21l3JFv0owum9rdDLoFc/hnsr8skzNA8MX7
	 FmIfZ9rYbyODa5rG2nAkP46XBIpl5xtUzn4kfXVI42zWf5x1aN6PTy1VYFG6rPrV8O3Gu
	 v35kBxdYoH0WK9rWSEa4PdQP3MdjXK7g0FRW9Yax0g0zYYLoA6LlH18mVukL8yzl2/yRd
	 lMz3FQ8DSdfYQSMuw8bkaXL3c8axQ+US+8NI/vuGT7YoEl8ZDAMwA0iOZadAk8gW5yk30
	 kQRsCl9CwzdGhTFLFr/oFE4hf3YlQFeG1Q20WHWZU3554bmxzDcDx4nAlNnTAcLzeNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b="p+/Yau80";
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DAB606A32C;
	Fri, 20 Nov 2026 15:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1DAB606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=p+/Yau80
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:references:
	in-reply-to:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XA6joGP5vLeK1TouEaq2G5Nj77T00m7V/e6BxV7FEhA=; b=p+/Yau80iiZl8UxuM2xM+XjUyn
	xGBd/mwyFqoOV/fhbk/GYOt1YvlWeTP3tkIgns5nY8KhNqrIula9XyK2przoVdmdXp0wQvwMeSgKP
	rae98v3mPNXVaLq22odBfBzFyZa4QtZl2FwLUtL5xVr4QSOGGPKOiHBxcxJr7SHh9a/L0VDbuz41L
	qLFJhjWTgC8n1wAj3osqv5G8v1Kn1vYIT5S5gKt+1i/ZGJ3UzY2o1HZfgnfPtbfPnM9v90yl8m2yR
	tTz5qxkvdLsQA2+B8TGfxpt3a2CgvA1FvVBXjii33BMgIubjcpwdrUR6ineio8wkhch1q3xJC40uw
	9XfQBeAA==;
Received: from 54-240-197-234.amazon.com ([54.240.197.234] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUQyl-00000007NcN-1Wd1;
	Fri, 20 Nov 2026 15:56:47 +0000
Message-ID: <64542ea2860f4f13394bf1e95accf32aae17aac2.camel@infradead.org>
Subject: Re: [PATCH 06/16] KVM: x86: Widen the plane vCPU fd ioctl allowlist
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>, =?ISO-8859-1?Q?J=F6rg_R=F6del?=
	 <joro@8bytes.org>
Cc: Sean Christopherson <seanjc@google.com>, Tom Lendacky	
 <thomas.lendacky@amd.com>, ashish.kalra@amd.com, michael.roth@amd.com, 
	nsaenz@amazon.com, anelkz@amazon.de, James.Bottomley@HansenPartnership.com,
  Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 x86@kernel.org, 	coconut-svsm@lists.linux.dev, joerg.roedel@amd.com,
 Mushahid Hussain	 <hmushi@amazon.co.uk>, Sriram Nambakam
 <snambakam@linux.microsoft.com>,  David Woodhouse <dwmw@amazon.co.uk>
Date: Fri, 20 Nov 2026 15:56:46 +0000
in-reply-to: <D0EE54A9-3FF3-4005-875B-A9AF04EB1341@infradead.org>
references: <20260608144252.351443-1-joro@8bytes.org>
	 <20261111222911.477-1-dwmw2@infradead.org>
	 <20261111222911.477-7-dwmw2@infradead.org>
	 <4e4fb011-9171-42c1-b499-27b0333a2fd6@redhat.com>
	 <D0EE54A9-3FF3-4005-875B-A9AF04EB1341@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-TZUhmNKuaI9sTewVZwmq"
User-Agent: Evolution 3.62.0-0ubuntu1~ppa1~24.04 
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-TZUhmNKuaI9sTewVZwmq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-11-18 at 19:10 +0000, David Woodhouse wrote:
> I've also been looking harder at the completion thing. We *can't*
> (well, I don't want to) enter another plane while there's still a
> completion waiting on the first plane.
>
> Which means any control register or MSR interception which needs to
> be handed to another plane has to completed first.

Aside other things which have been catching fire, I've been playing
with that a little.

I really don't want to mess with user completions remaining pending for
one (or more!) plane while another plane runs.

So in the case where we take an interception in VTL0 and then let VTL1
decide what to do, we need the completion to be done *before* running
VTL1. Which is why my idea of a cancel flag in KVM_SET_VCPU_EVENTS
doesn't actually work once I build it into the full VSM stack. It works
out OK if the VMM is making the decision, but not if we have to run
VTL1.

So Sean was right=C2=B9 and we end up with a per-exit field much as he was
asking for.

For the various exits with completions that are affected (RDMSR, WRMSR
plus the new register write filter and forwarded Hyper-V hypercalls) we
therefore want these options as the 'ret' action:

 =E2=80=A2 KVM_INSN_COMPLETE: finish it, as now
 =E2=80=A2 KVM_INSN_GP:       inject #GP
 =E2=80=A2 KVM_INSN_UD:       inject #UD
 =E2=80=A2 KVM_INSN_RESUME:   do nothing; RIP and everything else stay as
                      userspace left them

So the relatively common cases #GP and #UD are trivial to inject, and
any other exception can be injected by using KVM_SET_VCPU_EVENTS and
then setting KVM_INSN_RESUME to let the exception take its course. The
new VMware hypercall handling could do the same.

Entering KVM_RUN for a new plane would still process the completion for
the previously-running plane.

I'd quite like the UAPI to be consistent, and since the MSR exits
already use a u8 field for 'error', we can retcon this enum into that
field when enabled by the appropriate CAP. (Without the CAP enabled,
all non-zero values cause #GP as they do today.)

None of that depends on planes, so I'm building it in independent
branches which I can post separately.

What planes does add is two bytes in the kvm_run header, on any VM
which enabled KVM_CAP_PLANES:

 =E2=80=A2 the plane which took the exit, on every exit
 =E2=80=A2 the instruction length, for MSR and register write exits

The first means I can drop the 'plane' field I was adding to each new
exit, and makes the existing ones (MSR, PIO, MMIO) usable from any
plane.

The length is always valid for those two. On SVM without NextRIP the
access goes through the emulator, which was going to have to decode it
to skip it anyway. Not sure about SEV; not sure if these exits should
even be enabled there? I also toyed with exposing the insn_length as a
CAP which could then be absent in those cases (and on the ancient AMD
CPUs without NextRIP).

I haven't changed the PIO or MMIO completions. At least in VSM those
are never handed to another plane; what a higher VTL intercepts there
is a memory access, which is a fault before the instruction has done
anything. We could expand those later, if there's a need to.

So for VSM, the VMM answers RESUME and runs VTL1. VTL1 either injects
the fault into VTL0, or does the write and advances VTL0's RIP itself,
which is why it wanted the length.

That boots Windows with VBS on both Intel and AMD, with the VTL switch
in the kernel or in userspace.

The whole stack is in my tree=C2=B2. The planes part is in
vsm3v/planes-uapi; the parts which don't need planes are the
vsm3/exit-insn-v2, vsm3/msr-exit-ret-v4, vsm3/hcall-exit-v7 and
vsm3/regwr-filter-v10 branches there.

=C2=B9 https://lore.kernel.org/kvm/avuDUNAU_a933zvp@seanjc-mac.roam.interna=
l/
=C2=B2 https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dshortlog;h=
=3Drefs/heads/vsm3v/p4-startup

--=-TZUhmNKuaI9sTewVZwmq
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCE8Ew
ggWvMIIEl6ADAgECAhANkOKMSmGXhF5eMl0rsRhvMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBHMjAeFw0yNDAzMTMwMDAwMDBaFw0zNDAz
MTIyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UE
AxMxRGlnaUNlcnQgQXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTCCAiIw
DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOfSIeC0vv1xPQ+dgSxbIIrkaru6skAWJYaGFzmv
q4Kq+2wU2jxhcWlJg/JeP5jEkq/LM3pn5aaLao79j+XRmS7J1ZpJKUODJVoM4s9MQJhTMvo4qS5Z
S64g6QR7Obkz3I1Lr3aWeSBmDDEyzue+NKtuWZ1Cxy3RdXo/w5HgRc3l2AercOM3Gt1XonTzEtTb
Z/Hwc0Sn9Gz8RmGRK6Ka4hVDl8q/2l110KaV233Kh5etP0csXS8MIMdVRfRu3sc5hp13DG7lCKzK
72a2GEpI8Wpl26G6I1/LMzz/98T+FqjTqxsdquk7Cj7m2vKGLW1BorpQH7WFGPdJQXJe1hfbfiZA
CcVdCtl4nAacFacmsiArZBfX7AQGL7isvHUwwYFEtcApyGW4p2Lt+t8nvU0CANA6BHOpOz1xOP8W
mAESbUriIjyuTUf3fJ9oDNCurVqhASMJCDaWI3lYX/QAoiAzt6akqbbZxo2ujW7mGGqc0KxqE2cs
h2T79v7pC8aUtHBfwNrTR19GnZVxE0eQ7ViIQhR6mpSaUQFA9sG+cmD2G8TnCgYsLa0q8De6F61a
CBevQGHNzrbZ3JAMneveYg/Jy1XxQHDRcvrMfWKe0jjcWbdKYlaGVPm5V1ILwYz7Yv5ewo3NUrxI
GJiywe9qPhuJSDZs7VehTuI0FxGIsgKzVjgbAgMBAAGjggFcMIIBWDASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBT3m6JO05fF9DQPQw6Bhc6RkzKv+TAfBgNVHSMEGDAWgBTOw0q5mVXyuNtg
v6l+vVa1lzan1jAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMG
CCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
b290RzIuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdp
Q2VydEFzc3VyZWRJRFJvb3RHMi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUA
A4IBAQA+b8Uw53sDspdZgukU+qzLyyHkcjlxGGhHlP+zrmDLKm1wEFvCRS2pili3Hy67i8N4N5NU
vw5Rg6kv3lxb9S9Rktxk43k+tvm68pl7OxQE55ZjVY87P0lUPGwEqOOwLLyH02ZQcsfq5p5LrOH9
0JvmvZ1yy73HS+VpDAqOlytE0NSvTIRqFFkKQGQwfjvtql9YflujuNNvJztjBaHKYZsnNSg+J38o
jYq4TP3pSg3UdVH0PncVjPQyqxC9xef5Xae92Kbkzol3x7Nel3A1bwAkalrDMspvTHvey6LfiBks
FIqviTnoy7fgjaRAJgHS+RXx/cmuRd3rUAclSVVrYu8RMIIHAzCCBOugAwIBAgIQAzUotrsybJHx
HTjKOIVdIDANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
IEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQg
MjAyNCBDQTEwHhcNMjYwNzE4MDAwMDAwWhcNMjgwMTA0MjM1OTU5WjAeMRwwGgYDVQQDDBNkd213
MkBpbmZyYWRlYWQub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2pYux73kdbYX
sWF8f1u6DJP91qcqaZetsyfPkZk0B+MmXmAEv0kVes5n15V2mbDThOnpoPFly0UugQO9JYqLfrtD
tKD5yL58fgrDB9Dw+LQikgrHafl6YSCds5AvUu/8hw2J6noKrcOLJpKlKn9Fl/4IB9Q3JIdLx5aa
EtTqMalIPqHFOlgrJ7s+aua8xbB8YQ9ahqYBXWRJNv3P/2b1DYtdrz1oqZPE3CcB8Pc6Gf2a1Tcm
6TAgtEx7Cf1BFcrsrMz7TWHmGQITieNb2r9UYWSc2Gp+GtYFNJCgT0JJXKUBIauPMKBLteYrL8Fo
ff/uY44dC/mDWjdCP/5x0qelPQjlBvWdHL5zvBTOj06rJ0m3HNI/hnIcDh0Qu2j9reb9rLVcdym6
bWmBM4uDEB8Zv9Ph0KTBFSy1IosyakuD1j1Os30EzjGfbi0EUXIvnOcYbTBAbM5UAzrxEHMhBvoX
Pvnx+OyvjJmc9tWxTX6AcSz+m40esbT17URBeZS18afgieiikm5TynlUYP1LciR3hSgGVzvGXnKO
02VDFR5itGWdRKZ2W5wIShNfWfhSa0D0K5UdIDt5Qc7sjzwK1Yb1sY5Tu0uA5mhIS82q1ov83uxB
sFkriNnhGv/M1NCDVLBiOMsHu73qUM+yKmgKLwF9Hfn9WI25glbAMI4S5r3hYzcCAwEAAaOCAfcw
ggHzMB8GA1UdIwQYMBaAFPebok7Tl8X0NA9DDoGFzpGTMq/5MB0GA1UdDgQWBBRcYhqbcGzn1jrT
JOZaB8O7qllDpzAwBgNVHREEKTAngRNkd213MkBpbmZyYWRlYWQub3JngRBkYXZpZEB3b29kaG91
LnNlMBQGA1UdIAQNMAswCQYHZ4EMAQUBAjAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYB
BQUHAwIGCCsGAQUFBwMEMIGpBgNVHR8EgaEwgZ4wTaBLoEmGR2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0
LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsME2gS6BJ
hkdodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZT
SEEzODQyMDI0Q0ExLmNybDCBjQYIKwYBBQUHAQEEgYAwfjAkBggrBgEFBQcwAYYYaHR0cDovL29j
c3AuZGlnaWNlcnQuY29tMFYGCCsGAQUFBzAChkpodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
RGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZTSEEzODQyMDI0Q0ExLmNydDANBgkqhkiG9w0B
AQsFAAOCAgEAocabrh1cPd5s3vY5rnlBVQSTc7zs2ZWs67dAIltR+05WELrYClVzzUhMs/LOJPlr
EUo45UDDomXq38DxFepaPd9+iNLjXfn33EX/IG44j04lU/oF/Rg9VeQILkYLbCZ/x9wOjNHZc4SN
ydY7Dhvf/sT5aBz88u7D5+azZJ7Qf1U57wYseCH1Mt0nDrtr5y19IJ8D9xJJ33RFL6vfpHZBBAQ8
+3RqkKNxLoV2aFvQhxdhjNLDqTv3LjUIdicwPraN7JkxEu7CV2Lka7eRqJgkWL7SK0YmBjGpRafs
+icP/ON5RCCKTTb6VlX8eTG2sJJfsFhvJNCCt6xexbWzWtIrfP7NvPBvwBB737AyEGBZkS5aNizT
McURJGTv9UKvBh1LF/+tNhYtLvPCN7oecGzhCHht9jcwSkygTo3Y6YlK3QgOu+ncmiBbfeuwlLZ1
LxbYvG6hgNqXv7u6YyADbYajAQJXJ2OQen39pm3Q/AQSyLYG+B8lDglWsM8tYXPlEdrYJcksGK6F
nqIX6Bumn43rBooLJdiZp4WmfWdL2pxe+LxRDjprmqu1WprixDxULSTOKJZoqTlugs6y3Bc+if+s
gHnBBtz9WQ6MtPHkh7zONDAFIKcBmv8OqPQCx0F3Wv3OEybwMpXx0OsKgK8wLldaX1pXcMuyDgTL
Sqs0AV0OHUgwggcDMIIE66ADAgECAhADNSi2uzJskfEdOMo4hV0gMA0GCSqGSIb3DQEBCwUAMGIx
CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UEAxMxRGlnaUNlcnQg
QXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTAeFw0yNjA3MTgwMDAwMDBa
Fw0yODAxMDQyMzU5NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZe
YAS/SRV6zmfXlXaZsNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2z
kC9S7/yHDYnqegqtw4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qG
pgFdZEk2/c//ZvUNi12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41va
v1RhZJzYan4a1gU0kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0c
vnO8FM6PTqsnSbcc0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PW
PU6zfQTOMZ9uLQRRci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXt
REF5lLXxp+CJ6KKSblPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQr
lR0gO3lBzuyPPArVhvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7Iq
aAovAX0d+f1YjbmCVsAwjhLmveFjNwIDAQABo4IB9zCCAfMwHwYDVR0jBBgwFoAU95uiTtOXxfQ0
D0MOgYXOkZMyr/kwHQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3
bXcyQGluZnJhZGVhZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEC
MA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgakGA1UdHwSB
oTCBnjBNoEugSYZHaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZEcyU01J
TUVSU0E0MDk2U0hBMzg0MjAyNENBMS5jcmwwTaBLoEmGR2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNv
bS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsMIGNBggrBgEF
BQcBAQSBgDB+MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wVgYIKwYBBQUH
MAKGSmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNB
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
QoDoHMn6Y2bMuxqP/qpH55oAAAAAAAA=


--=-TZUhmNKuaI9sTewVZwmq--
