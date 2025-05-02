Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F74121C190
	for <kvmarm@lists.linux.dev>; Fri,  2 May 2025 09:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746177677; cv=none; b=UKjWqSU/Kez3H/OPMdmCc0ZpaJ9DvKSlvNiNgSZuJv4U6LDpdjI4M+SpBDWET2RpHz5K4RPU6h+whW6s12unBKk6Dhq193VCDpzROBw57YDSJAeNgNqyf3TWE+fWWvxLHRRxX2/qbcEEf+KlmI8WAbuT9v4hQ6n+6PPZuKvajfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746177677; c=relaxed/simple;
	bh=P0QsJ2rPVBEP2nxFeZDSTZmOmhyD2ZaBdrga+hkL488=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TpKwgQOpdIbAhOaadXafLWowlMejnmG8r+hPjAcSniHSnYotUL+WG5heLNfPsMZ3RpF0nTbFeb8QkFM/53HwPoC7Y5TTuws1aaQ8KO5FcBJoKY/YTJ9v7dQXo341DeFzrl4pZAiikhMxZDSGReO6QOxydPufLX8e0xO0Eq1j9No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b=j0u1eERc; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b="j0u1eERc"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e6e1cd3f451so1580569276.2
        for <kvmarm@lists.linux.dev>; Fri, 02 May 2025 02:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20230601.gappssmtp.com; s=20230601; t=1746177671; x=1746782471; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2A+cF1ypGsLN1/QniCjcaG5RIGOv1oGIJo5HtlBBUQI=;
        b=j0u1eERcvQKQIwswJ1JSvFh6sXTETUOEGYihduRzuScevEgIyLKVKdtZ37kia2cUyf
         gDYxKYFr6tY3RhD+7ZEgjAm8+gtHi6SgJPZeKE8Xt/Co8XKnl/Q1vGRwkLbtNWDdTrVM
         8Vdup0/HuoVHxSPAgzGeRAFvb31Td5GCkziOpbs5AJu8IT51gEohav5n3LT97Dc5E9nT
         6DN2H+ih63NeipZQbt7WdqmJnjI0bJYZF44KPYkpyeRzVVL5lk9WrncZ0lj+g40j99jq
         DaWVe//4TPXkMrU3uwCYSyX4Ww2QH8EERK7dLfIOE1Vi7aaV+XcluNNY78VmsZxgXlAT
         PPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746177671; x=1746782471;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2A+cF1ypGsLN1/QniCjcaG5RIGOv1oGIJo5HtlBBUQI=;
        b=O3lVP8RyNVstkDmk34PliYhmrgubwodRGSR891MdvzfHR/KSexoQ8aRaDE185HPImZ
         4sJTlYWqGl9xyQbhqgWHpMnof/YXrTkXryCIdrEzn+MldycDx1EewbbSoCbeP8rC3ok7
         8c5v3BIeuQktNgTKDoScf00cLWAL1ch6y57dh8nEMNpSqm54Z4eSgKh8Emb9N+qJDo3K
         dd9Hdy20oj9pnmnmPVmTyrduprQ8rWt6VGUmb72yFm5grtcVTftkAcPeLDlxl8vw/bqD
         LW+dS3av/4lsnJTkpBpxVMQfEzfNKYHoKaIJJ2IlkPXLbXYfvdB8CaTTX8VwxVzFdlLS
         hX3w==
X-Forwarded-Encrypted: i=1; AJvYcCXT3lqMISHuWEj2vBMdBK9fwD6sDtBW/sOPbbZ+fpqo8T1EtZITKuAq5l8I/9xnGzJ8nPYpJdU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx16R8lMxMWHVItqRav4m5umgc6MnS5nkW6MMdf5WU7l5JzYd32
	hvNp2aRUBb/Jyu7ctLMld6xa+2s0HOnKzkEa7qaoLc8uufEp00nUkXl5yIKbOks=
X-Gm-Gg: ASbGncvWfqT7X42Y+5IoIOf/mHaHnpm3F/vU9epghAb+S1cfZwQKIGd95uNASC3Qpb4
	HbRaO2C7oLDB5OzMqxQPhw8YUEM75/XBIU9GLm//q/ERZUN9jAD2t74rjlmTu0NYjMDyX2iMCzp
	ZSkWp+3cPrcf6Oxs/gHsuSHkBLihovWJpPm9SH99RlRGpdD6hTpVN5gSubwbUUTFu0RSyMrI6R+
	bGgNfoydErrS4q0QVW0z7e7PO6zJDcbLq0Uh/t6Ujp/PcR1DHG7p6ZMrvcWlyYbX/9JMul49aY0
	/Jhfpu+IDS6yY+rYdbXahXsdRO9ZAZbSySTntHu0ug==
X-Google-Smtp-Source: AGHT+IES/Q0SMdE8NP/DkStYtsSPsdbbvB4SZ0B+blj2b434IG8B0bEw+BlpUrAg4H/4nmm8w7JUpw==
X-Received: by 2002:a05:6902:200f:b0:e72:d424:8e35 with SMTP id 3f1490d57ef6-e75656272afmr2925615276.38.1746177671207;
        Fri, 02 May 2025 02:21:11 -0700 (PDT)
Received: from donna.immunant.com ([12.9.190.3])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e755e7d92d0sm556427276.55.2025.05.02.02.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 02:21:10 -0700 (PDT)
From: Per Larsen <perl@immunant.com>
To: linux-kernel@vger.kernel.org
Cc: sebastianene@google.com,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	jean-philippe@linaro.org,
	kernel-team@android.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	lpieralisi@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	qperret@google.com,
	qwandor@google.com,
	sudeep.holla@arm.com,
	suzuki.poulose@arm.com,
	tabba@google.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	armellel@google.com,
	arve@android.com,
	ahomescu@google.com,
	Per Larsen <perl@immunant.com>
Subject: [PATCH 0/3] KVM: arm64: Support FF-A 1.2 and SEND_DIRECT2 ABI
Date: Fri,  2 May 2025 02:21:05 -0700
Message-ID: <20250502092108.3224341-1-perl@immunant.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The FF-A 1.2 specification introduces a new SEND_DIRECT2 ABI which
allows registers x4-x17 to be used for the message payload. This patch
set prevents the host from using a lower FF-A version than what has
already been negotiated with the hypervisor. This is necessary because
the hypervisor does not have the necessary compatibility paths to
translate from the hypervisor FF-A version to a previous version.

Support for FF-A 1.2 in the hypervisor is added as a precursor to the
addition of the FFA_MSG_SEND_DIRECT_REQ2 messaging interface. The bulk
of this change has to do with the upgrade to SMCCC 1.2 required by
FF-A 1.2. Additionally, unimplemented FF-A 1.2 interfaces are added to
the list of unsupported functions.

Tested by booting Android under QEMU and loading Trusty as the guest
VM and observing the SEND_DIRECT2 ABI being used successfully during
guest boot.

(This is my second attempt at sending out these patches; sorry about
my broken first try and the resulting duplicate messages.)

Thanks,
Per Larsen

Per Larsen (3):
  KVM: arm64: Restrict FF-A host version renegotiation
  KVM: arm64: Bump the supported version of FF-A to 1.2
  KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler

 arch/arm64/kvm/hyp/nvhe/Makefile |   1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c    | 235 ++++++++++++++++++++++++++++---
 include/linux/arm_ffa.h          |   2 +
 3 files changed, 221 insertions(+), 17 deletions(-)

--
2.49.0

