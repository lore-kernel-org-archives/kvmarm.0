Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114347;
	b=5DhkqeLZCS+hQIBfrorzrnIWOcvImSW1n6mU0SYP9T2fkHsaWJR66XZKbYLy6DVtHFY4
	 LlHTDG7gw/Ijir1YYvbIoSz49E27I7XVdMH3q4bot3Qc11vfDrOS470goCP+OTeXV1vHz
	 B1YyCfCsYaMZgOBvzzaGzrY5q5nl1/joZINOsOFy6ZsCh3doLErLKAesGQJU1v+/12LW2
	 HoWDaHvi7v7LFouHU/GTBhPXPv4/OkYjTMGpJaKQe+n/k7r2qCYNTZlDo9Bht7xGJvKwj
	 b+b8pkY7a+ioZxU91q9w6XvuE8nwl+ytdxXYrTkE+qqwACj9k4T2OK/PptaCEQi9iUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114347;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=bNWLKDAO741BW0/XzcsTHBHCUfXie0HtjfUo7inFESE=;
	b=OXlzRYdSx41LRksbExECG1yYaVmlTl8jQWrvWhEej37lYHOvURwEskETc3jIl9N2SaLx
	 WV1O2NX2T7o2vxwWtuMOO5YlSur2BztD0G1BJEnJ9s6IIw9bq1Td9Epz8mJPx4jWIRsc7
	 yr+TAEo9MK5lZICVYGtQbRept2KZGOFJann1rk+4lDODvIrYcBiZ1Ulv7/xkrGvZUMJJl
	 j3sPGwbc1L7KBgr42ctpaphCGPHXlOxpc8AJoW4YGGRyy/uDhPHUyI0SLpRcxdcLNajhZ
	 iqCysg7RjF1EOpJ6vlSGJrdNe+wXlkzN1S2Me68rx1pS+jdwafh74TF31dipwFqK1tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DmaBAYzt;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C258B606AAA9
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C258B606AAA9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DmaBAYzt
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-860e65f42a5so109177a34.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114346; x=1795719146; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bNWLKDAO741BW0/XzcsTHBHCUfXie0HtjfUo7inFESE=;
        b=DmaBAYztPFYpckAO3gCXVFTtlNxAaAj5BgBqNvHunnJrLJ3Bb27saMzfZjnD33F8xV
         hecGejT8ZiRllpw4gL1z8QGZALJykWSPjVvKC9MrWV/YnzX8rpyqvmQTURDu3Rzza16/
         6uWkVfLnKR0AGKw+BByGGpfEunJysj6IV4ed+UQRIIn2rAHenGxpUD0oRqBGixbXaFiK
         fxohyhDBB7qa57Ngxf2I+zhvplzT3iOt/H8ovF3EQOXnWSNmulcirfsssk88NMb1yBe8
         xP+SpHnZ/VnWpRYuhFC5Z4ftLLiX+YEsezwbN0UGSlo9iW8Mz4cUaal2Gv9fZz1vvf07
         Zbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114346; x=1795719146;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bNWLKDAO741BW0/XzcsTHBHCUfXie0HtjfUo7inFESE=;
        b=h+OxJQiWKjaO3+2v2cmtUDd/xQkTg/GNWN9M4TAaJ5lzkPNBuc43PB884v3DVTOvGa
         Ajt8ms6+w+dyQ8CfShqtuduVerg9Pr9Hy17tcnWs0YbTnxpjTuJZZZT14T7nOVt1qipH
         1B+oQivKDJWb79c7hHMakh1xXryRgSpgvEM0IljjRx3djwcrGdfo79kgV3f8trBlf1nL
         +c5V4djsFMbpzEX090ccd3+l8zx6FxmFCY+ui8IwgReCylU1DbvwclpOoa7VS6z9jd/b
         bImdAhXQTFIRtgJtBfLBq0ub7x3jdfpe1My1YcaMDuQB+flKdRLa/I0DyqKMOBjNIJKc
         sHFg==
X-Forwarded-Encrypted: i=1; AL+hErElnQZWns4IJVPHDLG2kHJlFq4YL1iCYTOI4hn8QMZ4D7B2Ndf2FsU1tjyqoBBllnQ6kD6VbdE=@lists.linux.dev
X-Gm-Message-State: APuU4Z/mMWtORbBA4Ibtv4WZgSejwPPMfLntxmX6z/OIt8xn7/H1X7eq
	W1asxaDS6xrJ7T6hp0eKLcbxW4tkIyf1FpcMyLTJhUZl/8B2Cq6leg6LhoKN90vxNiCD+LwLlUL
	PZ7w8dfzGB3Hpmrdkwyzo/iaT8w==
X-Received: from iogs7-n1.prod.google.com ([2002:a05:6602:c447:10b0:9c8:85bd:e3c2])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1983:b0:574:4c3f:992f with SMTP id 5614622812f47-57a0bb6079dmr866880b6e.42.1795114345394;
 Thu, 19 Nov 2026 10:52:25 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:52 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-11-coltonlewis@google.com>
Subject: [PATCH v10 10/33] perf: arm_pmuv3: Expose number of general-purpose
 counters in sysfs
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Expose the number of general-purpose event counters implemented by each
ARMv8 PMUv3 instance at
/sys/bus/event_source/devices/<pmu>/caps/num_counters.

This allows userspace (such as VMMs configuring
KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS for a Partitioned PMU on
heterogeneous systems) to query the maximum number of general-purpose
counters for a specific PMU without reading PMCR_EL0.N directly from
EL0.

Suggested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 drivers/perf/arm_pmuv3.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 667ce27d2347c..1676f13cc7c38 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -457,12 +457,26 @@ static ssize_t branches_show(struct device *dev,
 
 static DEVICE_ATTR_RO(branches);
 
+static ssize_t num_counters_show(struct device *dev,
+				 struct device_attribute *attr, char *page)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+	struct arm_pmu *cpu_pmu = container_of(pmu, struct arm_pmu, pmu);
+	int nr_cntrs = bitmap_weight(cpu_pmu->cntr_mask,
+				     ARMV8_PMU_MAX_GENERAL_COUNTERS);
+
+	return sysfs_emit(page, "%d\n", nr_cntrs);
+}
+
+static DEVICE_ATTR_RO(num_counters);
+
 static struct attribute *armv8_pmuv3_caps_attrs[] = {
 	&dev_attr_branches.attr,
 	&dev_attr_slots.attr,
 	&dev_attr_bus_slots.attr,
 	&dev_attr_bus_width.attr,
 	&dev_attr_threshold_max.attr,
+	&dev_attr_num_counters.attr,
 	NULL,
 };
 
-- 
2.56.1.708.g77570a6a1d-goog

