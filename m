Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCEB45FFBB
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 11:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787052567; cv=none; b=cORH4ZtO957yOizUvdDZpuVUK51tnNODAJm+bFhk1mn42y3nSNuHSBUlXBiStfO/kmAAqRPCS235uypzqYxGtiRP6n51iBS0MD7DFeJbn9ayuUO0DA87/GfsW6jA9bWtPLvZxfYp12RYQaLbRzLbR3NhbDu7R+8NL+Ji+4nqZvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787052567; c=relaxed/simple;
	bh=IsTo1e1DGjsQsFENkKwvjFrz1btNflZZXlAX3fSz3fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o09Bph7WrvSkk+XykRhp5Snr1eiU/F/ERQIlqRPJXJP/0IwOA5c/T70XkQXCSzLInFgKPf8thjw+wTPEV6vWMMh5qrUachwwlm/EoqW5GjL2VF1SfwJ0cA78i0gft7OD/mF6yqZxLswbifTYaZ386ANmzwkDpyq2tJy1J6b7Pr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r+wJgBfh; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r+wJgBfh"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so3128064a91.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 04:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787052566; x=1787657366; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=A8znoO+3TjuD1sNEQAmiSPsrdX02VVlhlMJTSCrbk9Q=;
        b=r+wJgBfh+NBV2X32+khiDmZPvOtifnRbdbMfaKzC6SV2BdXaBKnF8FGSXORoZZgRzQ
         GOCT9KLi1jikO3amQXDVWkd+1MTofPwh1eafR47YIrPZiquUeWXuz6/U5L9bzXGMY5pX
         L1NVJ/HryoF6tKl1zWWOSC9jzpUsfEFOawWhiT/bzgVtZ2PIhrZdtMwZIl4b5w8nAkod
         GFIajxuLjvy/Vy5nbQ3FYgMnp/HjEjMn6SUYsgY+ru4d5cONTtBgzjhHcqESsKk41FaQ
         4S8VgAEtH97tB0jMo6qQn6NvHmI5YMK1mo4e+lYlRpifbjy7BArJ6XkP6W5YFn13x/pQ
         /Rhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787052566; x=1787657366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A8znoO+3TjuD1sNEQAmiSPsrdX02VVlhlMJTSCrbk9Q=;
        b=o3MV/uqFwjy3RfLB7JZ0LRG+2WcxkR6iNrJyJcTsqIeo/k+hg19EY864KbsxZcSoCx
         lhFHvDZsxCa6xog2kIHnsL4SSw/vlDfcnThTlJrHTsxzA9l0iArCJDQEn880fZ6hx96H
         vOENWJF9JfeBxsaSYFfjxuPHJuIrJf3gIpQ8sku1nB3aYF7Ou8bHX1EsAad6SaY5euJz
         sPUUOJPoV2p9mzyHLMr8+BJxJFFA21gbK+AW1TW98/hXkyc9Qv7LCSxiKvKgLDSbQW48
         ouV0Li1gLXHbO6nj31eJyd7OQS24olIrJemLxIzR0iLpouVp3TMfKY1sEHu+5L+Q+6d+
         73bA==
X-Forwarded-Encrypted: i=1; AHgh+RqdbnqrofLEiH8Cz7/sBP2QPYnXhIIFQIWiI+mc92VLsiTHp5iT0MO/FUXZeHWS8r3xcvDGmx8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxX29FDesTGiNZ0yUk4zQ+/Un6eS1mwDkvfV3slJ3agg95FxbUR
	HCirFur6XFHTnhVuEVPJpQl/SxOR0g99szkJGZ7s8NvL5AXKp4EuUM6x
X-Gm-Gg: AR+sD12tQpsVvCl1QH63qWn+9iGQX9OuP8SrA6XyB93+JdBTkwIQr7aqW8Ql8+f8Avm
	KGq9hTAN5oxjhyiXwGVc6XfNkslW7N7WK0e3ZNVrDXXPrEZanysmaIfoO9G1sCxGwW9UwH42WcA
	NJQzZKrl/OT8DYqUx3PhUbY1RnKM4yY09kOKuUn0LROBTl3V6xhoHAbgapCjmv3l/9XVOkQZXAb
	kb+zY+g2Z4BW0txibUb5COEt2qTLO0Pd/P2DH5xGbmaNKHrVWZOj4QvUlv9xim6Y0hvJX8Prv5u
	ob8XwB990DbmeLxZQW9oI6YYa6P2hzOJaqOrWsAVkrX3gCnwtjI5Fx7f9UAhkO5GfqwouLIB0M7
	qPk4SD2vwz2RyDcCG3jf0tQ5nwLBEl4vesgd06912Jv4JC8bquTJOcw1TVPKNLcHpueNddI8yCm
	Y7jhhFKWvNs03Tgj3xEWl+VewDiig3DFGlqktD02EsKhvIn0H9TvNCCtvIGAFT/lhPySNPBZK7I
	v8qOA==
X-Received: by 2002:a17:90a:38e1:b0:395:5f66:15f1 with SMTP id 98e67ed59e1d1-3955f6616c5mr6100098a91.17.1787052565657;
        Tue, 18 Aug 2026 04:29:25 -0700 (PDT)
Received: from LIKEXU-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531e31a9dsm8423420a91.4.2026.08.18.04.29.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 18 Aug 2026 04:29:25 -0700 (PDT)
From: Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: jiaqiyan@google.com,
	kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: selftests: arm64: Make sea_to_user skip cleanly
Date: Tue, 18 Aug 2026 19:29:17 +0800
Message-ID: <20260818112920.26252-1-likexu@tencent.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series hardens the arm64 sea_to_user selftest so that it reports a
clean skip on hosts that cannot actually run it, instead of aborting or
silently passing.

The test drives a real recoverable memory UER through APEI EINJ and
expects the guest to consume the poison and exit to userspace with
KVM_EXIT_ARM_SEA. That relies on host and firmware support that is not
present everywhere, and each unmet dependency is now turned into a skip:

  - EINJ injection is driven directly through debugfs, and an unusable
    EINJ (not built, no firmware support, or not running as root) is
    classified from errno and skipped rather than mishandled.
  - Guest memory is backed by 1GB hugepages; with an empty pool the test
    now skips up front instead of failing an mmap() with -ENOMEM.
  - Some firmware only arms EINJ poison as part of the trigger step that
    notrigger=1 skips, so nothing consumable is left for the guest to
    read. That case is detected and skipped rather than reported as a
    spurious KVM_EXIT_MMIO failure.

Tested on an arm64 host with CONFIG_ACPI_APEI_EINJ: on a platform whose
firmware places no consumable poison under notrigger=1 the test now
skips cleanly, and the earlier -ENOMEM and abort paths are gone.

v1 [1] was a single patch doing only the 1GB hugepage check. Following
Marc's review [2], it is expanded into a series that also fixes the EINJ
handling the test depends on.

Test Results:

  Case 1 (echo 0 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages): 

  # timeout set to 120
  # selftests: kvm: sea_to_user
  # Random seed: 0x6b8b4567
  # 1..0 # SKIP - Requirement not met: get_free_hugepages(backing_page_size) >= VM_MEM_SIZE
  ok 1 selftests: kvm: sea_to_user # SKIP
  # 1 skipped test(s) detected.  Consider enabling relevant config options to improve coverage.
  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

  Case 2 (rmmod einj):

  # selftests: kvm: sea_to_user
  # Random seed: 0x6b8b4567
  # # Mapped 0x40000 pages: gva=0x80000000 to gpa=0xff80000000
  # # Before EINJect: data=0xbaadcafe
  # # EINJ_GVA=0x81234bad, einj_gpa=0xff81234bad, einj_hva=0xffff41234bad, einj_hpa=0x42c1234bad
  # 1..0 # SKIP need CONFIG_ACPI_APEI_EINJ and firmware EINJ support
  ok 1 selftests: kvm: sea_to_user # SKIP
  # 1 skipped test(s) detected.  Consider enabling relevant config options to improve coverage.
  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

  Case 3 (modprobe einj):

  # selftests: kvm: sea_to_user
  # Random seed: 0x6b8b4567
  # # Mapped 0x40000 pages: gva=0x80000000 to gpa=0xff80000000
  # # Before EINJect: data=0xbaadcafe
  # # EINJ_GVA=0x81234bad, einj_gpa=0xff81234bad, einj_hva=0xffff41234bad, einj_hpa=0x42c1234bad
  # # 0x10 > /sys/kernel/debug/apei/einj/error_type - done
  # # 0x2 > /sys/kernel/debug/apei/einj/flags - done
  # # 0x42c1234bad > /sys/kernel/debug/apei/einj/param1 - done
  # # 0xffffffffffffffff > /sys/kernel/debug/apei/einj/param2 - done
  # # 0x1 > /sys/kernel/debug/apei/einj/notrigger - done
  # # 0x1 > /sys/kernel/debug/apei/einj/error_inject - done
  # # Memory UER EINJected
  # # SIGBUS (7) received, dumping siginfo...
  # # si_signo=7, si_errno=0, si_code=128, si_addr=(nil)
  # not ok 1 Exit with signal unhandled
  ok 1 selftests: kvm: sea_to_user
  # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Changes since v1:
  - New patch 1: drive EINJ injection directly through debugfs with
    open()/write() instead of access()+popen(). Classify the open()
    errno so an unprivileged run skips as "requires root" instead of
    falsely reporting missing firmware EINJ, and report a genuine write
    failure instead of the ambiguous "Failed... Success (0)".
  - New patch 3: detect when notrigger=1 leaves no consumable poison and
    skip cleanly, instead of exiting with a confusing KVM_EXIT_MMIO.
  - Patch 2 is the original v1 change, unchanged.

Not yet addressed from [2]: dropping the hard 1GB-hugepage and 4kB
base-page requirements. Suggestions on an acceptable backing scheme are
welcome.

[1] https://lore.kernel.org/kvm/20260817080759.25601-1-likexu@tencent.com/
[2] https://lore.kernel.org/all/86y0le9cvz.wl-maz@kernel.org/

Like Xu (3):
  KVM: selftests: arm64: Fix EINJ handling in sea_to_user
  KVM: selftests: arm64: Skip sea_to_user without 1GB hugepages
  KVM: selftests: arm64: Skip sea_to_user when EINJ places no poison

 .../testing/selftests/kvm/arm64/sea_to_user.c | 75 +++++++++++++++----
 .../testing/selftests/kvm/include/test_util.h |  1 +
 tools/testing/selftests/kvm/lib/test_util.c   | 15 ++++
 3 files changed, 77 insertions(+), 14 deletions(-)

-- 
2.50.1 (Apple Git-155)

