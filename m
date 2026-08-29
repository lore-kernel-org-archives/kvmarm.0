Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BC3361968
	for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 05:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787982626; cv=none; b=JoHDT1nm3OEIfzALq8CrVlERvPIqjBcw17KafndPol2C6ty7xC4zQZOSVgpXLIpzMEB2DD55nEYxywCgRZzorkKUkHp4V70D2J8qDiDcLzQECYLGmkNwcLYl11Sxloa3IWKpiiIgLBoY+ze/59V3OPUqb/b2fD6fFR6BnLRG1r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787982626; c=relaxed/simple;
	bh=Z+A8Tz7FckQ9L2HOE2LwzbrR7eujbvyPlVNZTZIai2Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IiXV+r4coRTdOZ0zO9dTGVAG8IDQylybNYGjjRiPTlsm2BszdPrKvxC/yk1AKkkMbotnsxl1lZTNk3xjbsZb1Sd9C2drr5fNYhISdjalfwd76dZIhaePHnY4BwctGIKDzd9HbjQAbZVI+Fwn69fKzbzHunRxwUAMSBzX6KEYh6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nexgEzD0; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nexgEzD0"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b0dd3c9a0so12094745e9.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Aug 2026 22:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787982621; x=1788587421; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ukS+6O6VUnt+grJqSVzkQJWIYuNE2DdB1/VCqDk7Wk0=;
        b=nexgEzD00ZTDF0DMAJD0HtY5nkrEzbvd6kj7LDnvTwuDNjeeCi0OZm97Z84cvaz0Yy
         rE5tXtZS2QgLyznwWrlPH5ZJNvqJbiT3VAamCUPhcM9VBUge+tO9DOwcxcHv+A3ODSgC
         bWRdiQ6rermiv/yedqn5crhAHJ2f0XfbaNS3fgfIbSrF8sWhbkBm9cWQ7iJxlFEyozXD
         0x4Gr+8MCkUWlqdwHuCCbof3houk6DKdj9XgI2AXvUS0WKQF9nw/MvzWisSbufPD6zGo
         RYyMXc/vUgnDJsQQqbFALWyWJtrwUCu1Jf7YvkTmSkWgCwXY0XInbtvkaxW+uT5CajKN
         spAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787982621; x=1788587421;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ukS+6O6VUnt+grJqSVzkQJWIYuNE2DdB1/VCqDk7Wk0=;
        b=ipaOvn+1wszGbu9uBc19N7voFErhQ1mlZdHhDwUB0bfis4Bcah5Wm022KaDu5W8dNg
         llhNILIsU03f2Udwied/VO7141ERnIdO52Z+5ZnEZ2smWP7bX/B0L+3qvx9zhaNdFUWE
         61F6Bc+DFCDmuDsEHB/CVEYajJbZ9uAqtmuJoeB4EAONus4u9ETcJgtHh77d5Co0znMR
         PMyY8w0hFUpWvakst5AVk3aP7YDwgwjTGZeZk4P20mmpEx7zzgI62+ix3NzTFWo3tXh4
         8un8PCHeynrKmhWmKFyl6iVZmTZPZptXt0lbkAYnwVxSOzg0WAQWlv2fA5CXBBIkh511
         hElw==
X-Forwarded-Encrypted: i=1; AHgh+RpJPRp/WUrraXSOxm+z+DFCv9F7NII+IFX9ZHopcQTiCZq9c6Nx/D2vRelnhZqel5nvA0aS1DE=@lists.linux.dev
X-Gm-Message-State: AFuF++kREuvskkiiIrsm6T/GZ9XTWCCzyNZX5CW3OcB3esRNLES/2/lq
	SgVwaFXs41FkEopBuVef8Anft9RiwWywrDYyqbaBc5j9VQrxChQY9k5O
X-Gm-Gg: AR+sD120xWZrDjmUnKXD9KIqIqWcbK2sRHYTKTa3J3acI5uVjPF++dtymAPCIk/yUY0
	lissj5OzN/vfGK5kFQvJ7TJYrQ5WAOuuS4yzvXvevkiYmi55djMdAWjGUXujQzNMoRLq9KWRLnT
	Vl/cwXf8vZ6VcJ+WTr3ZIqJzBtaX5TWCEm4X9VnLbzDjXLwctezzgie5woumbtSxoUTYgNIhTxn
	qvtxQP0pl5pQnZ006WOzu8J5fbX/t0ptgCCED+4NVq9KFierAOxG1J1L1wAscjc1XYHYGr2T/0s
	PsdocPdKOrhQJIdZGDT+ECujp0piZR8HO9xZyCh6fpQfEsZH0vfx6PDBhmIoag8cHAjEwcFURUf
	WJz0bC62A3jMoC/SRymPZHI8ZglEwAySmGe88v9XBELUMFPaKJNVJkB6QoExmKKSOJUKLp+AclQ
	aIzXjtPfs2p976sRIOxE2fFy7uhwA/f0tpeU3Pd/Pkz8YWH5qPwCsoaWSTYRbV1NTTS1gc3AQIe
	lf8bbilmv8G9iYLZscEsxgJH5euSo5bdD9l9dYOLUXICeXGHzFJZqENkHTw+f1F/yHCL8xPy4AE
	VL7sFZrZ96CViUhq/xLT
X-Received: by 2002:a05:600c:4715:b0:499:cd34:f7c with SMTP id 5b1f17b1804b1-49b91c26a01mr172319715e9.5.1787982621199;
        Fri, 28 Aug 2026 22:50:21 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-015-136.77.7.pool.telefonica.de. [77.7.15.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cca3e642dsm35357485e9.2.2026.08.28.22.50.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 28 Aug 2026 22:50:20 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/2] KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0
Date: Sat, 29 Aug 2026 07:48:54 +0200
Message-Id: <20260829054856.70549-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM_ARM_VM_SMCCC_FILTER rejects an empty range (nr_functions == 0) with
-EINVAL for every base except 0. kvm_smccc_set_filter() only rejects a
range if its inclusive end, base + nr_functions - 1, is below base; for
base 0 that end wraps to U32_MAX, and KVM then tries to insert
[0, U32_MAX], which overlaps the reserved Arm Architecture Calls
ranges, so the attribute returns -EEXIST instead of -EINVAL.

The request is rejected either way; only the errno is wrong, so this is
a minor UAPI validation fix.

Patch 1 rejects a zero function count explicitly. Patch 2 adds the base
0 case to test_invalid_nr_functions(), which only covered a nonzero base
and therefore never caught this.

Tested on an arm64 KVM host in VHE mode running under QEMU TCG: a small
userspace reproducer gets EEXIST before patch 1 and EINVAL after it, and
the smccc_filter selftest including the new assertion passes with patch 1
applied and fails at the new assertion with EEXIST without it.

Karl Mehltretter (2):
  KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0
  KVM: arm64: selftests: Test empty SMCCC filter range at base 0

 arch/arm64/kvm/hypercalls.c                      | 3 ++-
 tools/testing/selftests/kvm/arm64/smccc_filter.c | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)


base-commit: 548e7bcd0c5460ddcbca9600cea603ebeebf4da7
-- 
2.39.5 (Apple Git-154)

