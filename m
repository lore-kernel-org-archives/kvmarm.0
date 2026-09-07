Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3092DCBF8
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 04:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756284; cv=none; b=lm6/UZQ2MBp76mOrrz9e1NWSBsmvMAkaX9huiuFXPIhJCbfeVfXEUrW3cjnirjcVEwOaXQJaTPdDijZY5C4I32shA6X+sq4zeXVAo1LEd51BZnXMoFo15i9oq+5MxnEwPlh9Cze0kbWJ2SXb+IEiNRUvggjUIhAQe51KilyKpDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756284; c=relaxed/simple;
	bh=ISslVk0idEPj7E8QqGvX7pQ3utIJ/ZKVkkttDiU8+jk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BC4sdvGo3yaZKLuF0fNRjM+ZE1WlIa3Vy99CN6XWaukU/u8OGrA9iGfTZ8Af8jzu+rcpDC8mtL0jKzQ5pHXUw5q/NiY7NxtUMDgyZn0ixxTBvjYBLFNPUvYaA5sQUWl5IZY9JzwjLFgpL4TIRUDYMrA3kmm6UVd8OFtl0rSmxVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=riBeI9RR; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="riBeI9RR"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3964dfb5a69so4148023a91.1
        for <kvmarm@lists.linux.dev>; Sun, 06 Sep 2026 21:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788756283; x=1789361083; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tEZDkgun1SxnDcq7CXUxTgN3EXXb5PDIeu9LnAI4BVA=;
        b=riBeI9RR9g/bQwSj2hiFh0m/VA6oaurvfkU9bpg0etRXvysX2PmuTRTrYk+/hmJDJT
         85cQmYmf3j7oqWmBB/RlngUDH7rrLVpRs+m1HKKIBpZ++uhaIc9sHQSmA7lb2UFItu7N
         Z/kduq+VrjZjmJTpOtHW8IbU1z+StrjtPYlqdS9oMu8XYgLisRLdYfl8SEa/+JpGwBLG
         FfAVENfNl4xX888CGMpcnKkvAp4sXs0NAZqq8CywgpofFdbqD92sHRJoc47eFTGIGwSa
         AdTKXt5vppH30xW1UcXMfQ3KDpWNiVC6uCx8k23r+mxw5hc9Q/WV3uD8ZkzrkrrFk1c6
         j7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788756283; x=1789361083;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tEZDkgun1SxnDcq7CXUxTgN3EXXb5PDIeu9LnAI4BVA=;
        b=YHPhvfG/z3YYfcF2XNOYBJIfVkPzkDXZo40uSO+KYx8I92Oh1Z40WJxYreNkEdVYlP
         IOrQPB3PlLJIGbvRPcZsKrKfRewcaWGuII6dt/iNsFkHvL8irv8z5YVomvbAIFWHuu8v
         06jRTTvHflU3Bzyzneho3HKDRjPLTUdmdVK06qdrXS513bBRQhipIJ7ymhk/Jpc0V0FT
         3GeoM0xzZ/1yfR3H+koTEEaTmD9gGoSl8NFkSb6P6taxbB/mGTJ/V/5x0jXTxBv1nBRA
         5GHTrCAasEBBcVbor1XHfLEvq837Sn9DO3nE9mGstLgg2Hi7n23r82aD8pdczq31GR3d
         hRGQ==
X-Forwarded-Encrypted: i=1; AKwUvBzTbqXw/6en2po5fQuGqBYtBz4DcK2ZIsrB5eaCneimPnQH+/ZHxtMgiAdDFFOeLLRpNXo8T6Q=@lists.linux.dev
X-Gm-Message-State: AFuF++kqPoHgGaiSpAvmwicyByYXBGrhwQRK0aDhVrixavJUFdThhIAx
	FTdZS5FoJaNJClLtd1svECvzMmKiqMCTY7RsMAM9DmDoR789C3hia1Jz
X-Gm-Gg: AYBFou1XHf/uJyQuasSKmV4E5I0a6J+4Qp5GUew9TJGAU7SJKsRS0NSyXHbkqMXMYqT
	USc5bdiDJ5fwEBeVS3evSdVF7cUuKAccaX8J8+vfkdw5Qs1u2mw8vygtIcwVkkzBlMes6U7uUOb
	Xk/cqHqwzErUNh5Q1IhnlZQSIevsB4Go/L/g0BCsK2yfYdeSS8LzA9cjC1JUF0v7iCgRLVSL/Yn
	HhrRlPiJ2oSiXuUFyNCaIJ7lVpe9oTzqnXdCxBZv6cb/AuWNdFhfwtuO6wli75uR6wFWW9fDIl6
	o4TcOjpgil+lKolT2akHuBi7Kj6zfbf29boQjAuZdybD36tEZZPJtXaD+n/Df1ooiu4m1w+AVlu
	83rAbIhwGvfMpJcfCeIsZUh+5X3d38a15JOD8RHgEzqYd1qAqyab5/ET8CFQFngaE4QL4Cy7VC/
	SrNNYpHxmd+ppIfOa9Xue6kmkz8y6uG9cGey7ihSls7RND5PRHZbf5I6UgGMlRP/E2KRaLueyHA
	UHyWxVyK3GEsw==
X-Received: by 2002:a17:90b:2ecd:b0:396:40e6:f631 with SMTP id 98e67ed59e1d1-39b2609f306mr35329992a91.3.1788756282789;
        Sun, 06 Sep 2026 21:44:42 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm37823751eec.16.2026.09.06.21.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 21:44:42 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
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
	Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 0/3] arm64: fix typos in comments
Date: Mon,  7 Sep 2026 10:14:31 +0530
Message-ID: <20260907044434.4682-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of the spelling fixes for this tree.

Changes since v1:
The pauth.c change is corrected: the doubled 'is' is a misspelt 'it is',
so v1 deleted the wrong word.  Spotted by Fuad Tabba.

Only comments change; no code is touched.

 arch/arm64/kvm/hyp/entry.S                           | 2 +-
 arch/arm64/kvm/pauth.c                               | 2 +-
 tools/testing/selftests/kvm/arm64/debug-exceptions.c | 2 +-
 tools/testing/selftests/kvm/arm64/hypercalls.c       | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

