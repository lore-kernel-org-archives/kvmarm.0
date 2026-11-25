Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620982;
	b=nCYL5yjTEyH4hOpJN7kdawiqfuryu4O17bcR6c/dwXSvaU3jMHR9r/YrWcYy9C9/B6gS
	 9EVClOowPCe2+HdkVg+sOzSdFSF0+UzpRzEXtHLj7sD5W+qoJnmexC8Acw54fP8FGM6mV
	 wxe2KZwr+zs0W2y2VCZdMKP6Qr7IAvEPviyC9j9jO20itV3ldUN7wHTgenhC3s8WM7aWM
	 SiW/s3u+Uol4bnDzuQglxN+HRRvs6Cy+p9vEzFlyHgKM6MP0cO46EmSHlxypolchPWHVM
	 568o/D65B68PGdmZ8dC3MI8aMH0UUggCMJJrpOQeXs4q+bZXO0YQNN7ITfXzJ0l0FGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620982;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=kdXtsK5oiGz6RmA/ZpSIqAQiVji6Qb7T5uYbNNT0Kak=;
	b=G5QM5ZOTRB07x3SNDg4Z98LyQLspHoImrj0k+bBBK4lO7T/UBe+2lirIeexzIp/+EUgG
	 PG/BsKK1WujpXgpaRJHMpAL6f3BSozF9UnDitG0QELcSb/jsdA77s9TKFgTSD5H+yprCI
	 HrsNfg6snfxN3zuL3Y1+rSaZQRtkZQ/rMXHQ1JSaZHHm0k+781D5V6AmAcQSBiBC5bF1B
	 cnZjj0C9TmlShineUw0wdIQ01BbryZ+MTaTyyQaYQTQhF9rhAbQQFD0qtUiFIVRbMMPoO
	 oOSszql1dkEpaGIRPurCBJ6Wqmt90OCyyB/FiytLaMW7t8asIUGhjqe714GseS9daMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=AdXHw1wu;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E969606A69B
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E969606A69B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=AdXHw1wu
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e3b22e971so3133494f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 07:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1795620980; x=1796225780; darn=lists.linux.dev;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kdXtsK5oiGz6RmA/ZpSIqAQiVji6Qb7T5uYbNNT0Kak=;
        b=AdXHw1wubZWrkqODQX2WsG53QVUXsrOGMqTtve9pjt7sEHyRp5gQeyFU/rKQNAHFUJ
         UmhvLD4jl+uBEcRNre/h1lkVdUMhEz2MX2jeM3ynku/B5I60LckqX3bXaJwuBiLPjZpE
         1OOw/vtsDyj8dbQHQiNB2vt1majMWTKMsJ9M7OSAA1xizaG345SchilBA2KpdW3PP9zv
         S8jeJge5Ig0F/s63X6T+hha9v5356mAPk3oiu7ke49Ivdi99Oxhbyfw9mPWmfq38uGKQ
         6yy/s2mIRCMDgjn1fq/5BTWQxFYwUFkquxdrIwTBZqzoiU4HsWYtfYGhD17alLjzv9nN
         oCbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795620980; x=1796225780;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kdXtsK5oiGz6RmA/ZpSIqAQiVji6Qb7T5uYbNNT0Kak=;
        b=dZ2u1S6iIHaU5Hmg07uey4cQa5RDdtYkHmy9577spJZhwU5B88PHUMj1IpkSRrXqlm
         4eU46tDZzI/zLgnUigleJVmXXnDdvfxiXmFp1gTZk0uj51rldP6LyawsgakDBi+QPGS4
         ezYrgXI90TZq52D86hPB5V3hX+db5AQR7gaqxBR4J0Z/dOrhrBnqaHDXLOmH8pnW75Y5
         4+6sdz9VYdGhiaW1cFaKmSqIDpJK59oqUplj5jyE8ptH+ZQXg27kwaPMm36WDcViAo6w
         fsuLU1QStthRylfUwH1rSRMSvt7QENIHjegQFNy2Mha2eiNZ6bqE+obt5FTrykRjpIO9
         DIFw==
X-Forwarded-Encrypted: i=1; AL+hErGUrFDR3FA+hjV7epp51h0VEArdVAeX1MhxdzxwRsDv60lcMRUtAJxJdjs+ni4qTeXGhawO1wQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z/YrU57D+odwTR9qfdnQP6ERp1ug4++8vX3r0f+AhXVSRfEPA2k
	aubOExuCKM0m/i27n+Q6VUl1yMvn5QrPlh1ovk1m7e2HZ9QLb7eNMsATA8FvQpKemSo=
X-Gm-Gg: AZFdTZfbANCUD9/hfpgrjd76zR0bdrHGJcFR7nnd+CdN4TTGnKdAwMyGgimm+aWihgU
	LxNSlR7w2Ox9gGVJs0kpMOQ9BigDKakkzJtspZ26PIiq+61CaLNNOCwjR1hJwd7HppfN0oltpRY
	ttbnKAoziu7MYSoQrQOLAEDGNa1ZExENOxHRzfW670TipAp4bU3G3zRZw4qOGjg78F+oqk6d1Hv
	KIEyvFT1+ucW7qgQcBOujj+674pNk4QuN1Uh13jY7s1XRqn4Xo78b8FEHgBmwJ0yDSpKYSgrSlG
	bhXmURWo2rtoYLrfZYFcjQfnb8Va3CQxnjvWpDo+JO9e0YlVhS4MfOampK6dSp2DTw7NHQUA/OO
	HJhmlz+8fbiWp+s7IaH/ctM4b/PzmTrYTJEAyhFqPGbcdqxfwHlR1sHx+WrINqvwyxDZxDWmkBq
	/TwhiK+IvS6BJtxAdQDQaV1r8vG0TwLtsumtptL1m283KsFjkeVS9ZbbWGaqkdBLUfCjhEjsBFd
	H4GC/6aJr4XiU24AD8f3oq73858vvnzaIwHX/aWyODOSTWr8KhQ9I7a/+EnXDxd9IMRPhiHpxaD
	JvXK/Tyl561Jcf2XGOvfGVYMSJV3LI5BYNh3qoeS67sBVGkx25Jgkw==
X-Received: by 2002:a5d:5849:0:b0:4a4:4229:c3a2 with SMTP id ffacd0b85a97d-4abaf7401bbmr39868108f8f.11.1795620980437;
        Wed, 25 Nov 2026 07:36:20 -0800 (PST)
Received: from pop-os.local ([37.18.141.193])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b8e564e39asm5382635f8f.57.2026.11.25.07.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:36:20 -0800 (PST)
From: James Clark <james.clark@linaro.org>
Date: Wed, 25 Nov 2026 15:36:03 +0000
Subject: [PATCH] KVM: arm64: selftests: Pin vpmu_counter_access to one CPU
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-james-kvm-pin-pmu-test-v1-1-c3ce989233fb@linaro.org>
X-B4-Tracking: v=1; b=H4sIAGIAB2sC/yXMTQ6CMBBA4auQWTNJW1B+rmJcIIwykJamU4gJ4
 e4UXX6L93YQCkwCbbZDoI2FF5eg8wz6sXMfQh6SwShz19rccOosCc6bRc8OvV0xkkSsjCqaoqm
 VKktIsQ/05u9v/Hj+Letroj5eNziOExjFhCt6AAAA
X-Change-ID: 20261125-james-kvm-pin-pmu-test-720393980044
To: Leo Yan <leo.yan@arm.com>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Colton Lewis <coltonlewis@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 James Clark <james.clark@linaro.org>
X-Mailer: b4 0.15.2

The vpmu_counter_access test reads the maximum PMCR_EL0.N from one VM
and then creates new VMs for each number of counters up to that limit.
If the test migrates between CPU types the limit may not be valid for
the new VM which causes:

  ==== Test Assertion Failure ====
    arm64/vpmu_counter_access.c:483: !ret
    pid=9165 tid=9165 errno=22 - Invalid argument
  ...
    KVM_SET_DEVICE_ATTR failed, rc: -1 errno: 22 (Invalid argument)

For example on a Radxa Orion O6 with 20 counters on the big cores and 6
on the little cores, this happens on most runs.

Fix it by pinning the test to the CPU that it starts on before any VMs
are created.

Signed-off-by: James Clark <james.clark@linaro.org>
---
Assisted by Claude Opus 5.5.
---
 tools/testing/selftests/kvm/arm64/vpmu_counter_access.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 22223395969e..e7eac736260e 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -626,6 +626,9 @@ int main(void)
 {
 	u64 i, pmcr_n;
 
+	/* get_pmcr_n_limit() can be different across CPUs, so pin */
+	pin_self_to_any_cpu();
+
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
 	TEST_REQUIRE(kvm_supports_vgic_v3());
 	TEST_REQUIRE(kvm_supports_nr_counters_attr());

---
base-commit: 5715eba4f80a7655d85581c6c951b71d2abbd725
change-id: 20261125-james-kvm-pin-pmu-test-720393980044

Best regards,
--  
James Clark <james.clark@linaro.org>

