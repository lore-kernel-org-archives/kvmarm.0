Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE226242D6A;
	Sun, 10 May 2026 22:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778451120; cv=none; b=uY+wtrm1zfpxCjIGfRXrdOPeH9QBoadIpWaZvsq+URXiWcResPGJy7//GJhFJHGSvhP9VvTTXWWgRAxMGyjjb11Quzuvmq1EWynPptdeBGtgrT5VfCknD/Z2G6kf1D5LXFAzIGS8neFwPkuOprCb/cNFsH/c402glZXGmwZBqMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778451120; c=relaxed/simple;
	bh=KAA6p2i7xNhE3MaKjO9sLKs/euAXtqyygZHVTtczz7A=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=hGpAh1hWQFZDnS/kgSi//Z69BUXitNnoq6gPg0XOrllD03Fe/B4YG5BUUjuo303tm13zc3+rXYm/l0zjEs9YjTRZWCoj2QrnwpPKZFxKAwpXHh2c861030d0H9Z0Jyw5BdpOIBEokUMy0qcfAEu12EW7uJ82zKRjpUR5BGlT7KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aFL9uz7T; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aFL9uz7T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:To:From:
	Subject:Message-ID:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=77Zg783VrPv87K9sXBqm8YiYCgmGnFlFS5aCfEu+93k=; b=aFL9uz7TmFvha+HSwKHFofi3GS
	0kFjeVSc4UE3MqaEqC4ykQiLtwA7BWXxCGxMU9nbKqsh5nAvLXyl6K4BL5fSu2ZwJQb4lkHomcZMk
	FJXXMqbstGNQHUhoAqhLtG8O/vcdjdD6Z3VmjW43UYsBIf81wh+jDF4VzftpRsrMm5AfXbCyhzV9j
	hiFkIorSHZDLKkB040Svr4xp5sa0f0FGNxByJ6fmZ2EhKnaSL4CPGnXmKvQUDrcsw2BLxSsMbEpgn
	LUwvo2Zhsk6hAtHaeuup86QM681mLxCcE81xXMIcPyYPGRRSFHaJYHeRNVf6865DOoBU+ctSyH8VE
	udeZaQww==;
Received: from 54-240-197-234.amazon.com ([54.240.197.234] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMCNE-00000007Jnj-2e0u;
	Sun, 10 May 2026 22:11:45 +0000
Message-ID: <6564c8b967948e30a8d3f35b6ef5de79dd5feeb7.camel@infradead.org>
Subject: [RFC PATCH] KVM: arm64: vgic: Skip vCPU trylock for pre-init
 register access
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey
 Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Sascha Bischoff
 <Sascha.Bischoff@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan
 Cameron <jic23@kernel.org>, Eric Auger <eric.auger@redhat.com>, Raghavendra
 Rao Ananta <rananta@google.com>, David Woodhouse <dwmw@amazon.co.uk>, Maxim
 Levitsky <mlevitsk@redhat.com>,  linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev,  kvm@vger.kernel.org
Date: Sun, 10 May 2026 23:11:43 +0100
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-Ro5SzoKkXs6S8pUv+ypN"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-Ro5SzoKkXs6S8pUv+ypN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

When creating a VM, userspace sets pre-init distributor registers such
as GICD_IIDR before the VGIC is initialized.

Strictly speaking there's no reason this couldn't be done at VM creation
time before any vCPUs exist at all, but the design of the userspace API
does require vCPU0 to have been created, as the system-wide registers
are effectively accessed via vCPU0.

So a VMM can't just set the IIDR at startup before spawning vCPU threads;
it has to be done once the vCPUs are being created.

However, kvm_trylock_all_vcpus() makes it unreliable by causing spurious
-EBUSY failures if any vCPU cannot be locked. So userspace is forced to
create the vCPUs (well, at least vCPU0), and is then forced to have a
full synchronization point and quiesce them all in order to reliably set
the IIDR.

To slightly reduce the pain of all this, skip the trylock when the VGIC
is not yet initialized. There is no need to lock the vCPUs if they can't
be accessing it anyway.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
Other options would include making it possible to set the IIDR before
creating any vCPUs, either by creating a new device-level attribute or
special-casing it not to require vCPU0 for DIST_REGS that aren't really
associated to a vCPU.

Deprecating kvm_trylock_all_vcpus() and killing every user of it with
fire would also be a good option, perhaps... :)

 arch/arm64/kvm/vgic/vgic-kvm-device.c | 38 ++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index a96c77dccf35..e17ea9f07f5f 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -540,7 +540,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *=
dev,
 	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
 	struct kvm_vcpu *vcpu;
-	bool uaccess;
+	bool uaccess, vcpus_locked =3D false;
 	u32 val;
 	int ret;
=20
@@ -566,18 +566,37 @@ static int vgic_v3_attr_regs_access(struct kvm_device=
 *dev,
 			return -EFAULT;
 	}
=20
+	if (!vgic_initialized(dev->kvm) && !reg_allowed_pre_init(attr))
+		return -EBUSY;
+
 	mutex_lock(&dev->kvm->lock);
=20
-	if (kvm_trylock_all_vcpus(dev->kvm)) {
-		mutex_unlock(&dev->kvm->lock);
-		return -EBUSY;
+	/*
+	 * Pre-init registers (e.g. GICD_IIDR) don't need vCPU quiescence
+	 * since the VGIC isn't live yet.  Skip the trylock to avoid spurious
+	 * -EBUSY when vCPU threads happen to be running.
+	 */
+	if (vgic_initialized(dev->kvm)) {
+		if (kvm_trylock_all_vcpus(dev->kvm)) {
+			mutex_unlock(&dev->kvm->lock);
+			return -EBUSY;
+		}
+		vcpus_locked =3D true;
 	}
-
 	mutex_lock(&dev->kvm->arch.config_lock);
=20
-	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {
-		ret =3D -EBUSY;
-		goto out;
+	/*
+	 * If the VGIC becomes initialized between the above check and taking
+	 * config_lock, drop config_lock to lock the VCPUS.
+	 */
+	if (vgic_initialized(dev->kvm) && !vcpus_locked) {
+		mutex_unlock(&dev->kvm->arch.config_lock);
+		if (kvm_trylock_all_vcpus(dev->kvm)) {
+			mutex_unlock(&dev->kvm->lock);
+			return -EBUSY;
+		}
+		mutex_lock(&dev->kvm->arch.config_lock);
+		vcpus_locked =3D true;
 	}
=20
 	switch (attr->group) {
@@ -612,7 +631,8 @@ static int vgic_v3_attr_regs_access(struct kvm_device *=
dev,
=20
 out:
 	mutex_unlock(&dev->kvm->arch.config_lock);
-	kvm_unlock_all_vcpus(dev->kvm);
+	if (vcpus_locked)
+		kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
=20
 	if (!ret && uaccess && !is_write) {
--=20
2.43.0



--=-Ro5SzoKkXs6S8pUv+ypN
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDUxMDIyMTE0
M1owLwYJKoZIhvcNAQkEMSIEINGYAlu4AoCOHhMHPbsf0T6+z3VaEmdPWqBwVQo7sUaIMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAAgVBe6YoEsgQ
mkvTLR03IkRxyt7Fj/hgzyM0BoHZScSxtylhrOgL3MG7SxyW/NbP7OKRatNif5ga3GjbWBUyHxjF
z+NI7v8hSmXY8O1cdO8Ugw1kvGJdpdOWO/e85F9FYuWwtTvkO89vAG2LzvLhH1Skgp3J/lrzYSJD
8k95QyQEBt7bgJ1iTRSPAnybqNway0SjHn5tU0ns9WwObKo7xUE7V3YEqHyHj6M44hatmmt0aQgi
bivM4JUasmGylM1jFOTUmeJlcOUv1O2oY7Z8XmPYG2h1Ia6w/nPvTLeavZynT+zybk0GowdzO7El
HFbO+T7bgjFTDudacKHhEUOjJLIsx9zoiuhXwgVRWS4rai4NBGtVexBTx4ykDWmP70EBRg08+uWU
GVZnsasvQoMhvp/A1eceQDGYZUPgkgD8oZoPNZmBfxZsIDuDULxzELEO1xpBZw4E7hTuHZyCXkMp
zbnJgBjpXcRLDp2vMKzDsiXVxFdRqymFqArp/4fFZXFogz4z6y5YjvEUex0PGjTEc/PlG0WE3IVM
AVZmqQ5XJ8990sl42hePEi9Sc/xmjMmPZfI4hK37JSMy+Tu7YQIRqpE0hG2Xh922RcWfKce2zKVV
d+y5CtOvbSLfpCKxnyZSvLAYnb7Jxjwexibp57ke60APGpx3KhPsoBVdNpRt0akAAAAAAAA=


--=-Ro5SzoKkXs6S8pUv+ypN--
