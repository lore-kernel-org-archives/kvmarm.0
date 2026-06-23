Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538922BE621;
	Tue, 23 Jun 2026 13:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782219781; cv=none; b=gg06bvBM2ojI8C4w/iQO8saL3rcXQyFYW+Ka7tBpRzbnBtv60kw7faeeoMuxQHsagQE5GUq7QAuSYW9O7IalHEK7UUqrWefV2FPcGcXWI2FWYB/dkOSS/Ta+lMSRQ7tDJLahnKv3XbpGGw9SGG1mBL4Bt94cX7y/qfLX3da+AL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782219781; c=relaxed/simple;
	bh=UKxLulHrMeEhawIobmJpAHpxl5LGhIo5vPnLUY05Kyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KutpRv7wonh36KyBN4Ubv4/ds+HvT8QXCSV+ieBrsdq6+VzUleC8noLNh1tXkGNjFJUqnWKLZgb/KMhzmuVRNxZqy4VTJ3AX2HagFAydTGDzZ8h7glsWzQ8FJSMlbg2aBtU216ZCRN49dD7VpcCl0iPJJ2Bx3eQFh9L+BcaTGVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eN/qzKvq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eN/qzKvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530831F000E9;
	Tue, 23 Jun 2026 13:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782219779;
	bh=Ic50QGLcvtZ0vS3i/+z4+DL+suRayRsebfMRMDJCfJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eN/qzKvqGAInNy/HebvMYGmi9onQQpGC8yfBHiYsfyqh3jKSOK8vTZhQNlkvPADAt
	 QoTM93ttGyukAb89gMMID+mAn6Il4qrjbbTKjwm5OomWfXwQ2W5501YjmXweN0I/x9
	 suendL34NNi5wL9csRkkbAmyi5d5NqeMfemdfvntb0jfZ5oT+L41G1v09dqqurUdMy
	 ONXsMJ+Yo+LU1U0nEDcwDBapF8D1lpKW8rAtFh3HxQBC/xiVVI/MEsimTgGnY3B7Fy
	 5sU2WmqG5TgrlkZiHtIaNS5PmfoMBVt8Nsg3sh9rff4w5/AKxFxpw9Rl8EkUBAcDYr
	 PdOOM8QvrJLnw==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oupton@kernel.org,
	jean-philippe.brucker@arm.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	seiden@linux.ibm.com
Subject: Re: [PATCH kvmtool v2 0/7] x86 compilation fixes and arm64 PMU improvements
Date: Tue, 23 Jun 2026 14:02:41 +0100
Message-ID: <178221837797.2618973.1411525576893271029.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618155001.226266-1-alexandru.elisei@arm.com>
References: <20260618155001.226266-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 18 Jun 2026 16:49:54 +0100, Alexandru Elisei wrote:
> v1 here [1].
> 
> v1 was sent to fix this compilation error:
> 
> disk/core.c: In function ‘disk_img_name_parser’:
> disk/core.c:27:21: error: assignment discards ‘const’ qualifier from pointer target type [-Werror=discarded-qualifiers]
>    27 |                 sep = strstr(arg, ":");
>       |                     ^
> 
> [...]

Applied to kvmtool (master), thanks!

[1/7] x86: Define bioscall only in 32-bit mode
      https://git.kernel.org/will/kvmtool/c/4ac426b16525
[2/7] virtio: Do not modify const strings in virtio_9p_rootdir_parser()
      https://git.kernel.org/will/kvmtool/c/ddb340d8bcd4
[3/7] disk/core: Do not modify const strings in disk_img_name_parser()
      https://git.kernel.org/will/kvmtool/c/63a29eb4e73e
[4/7] arm64: Initialise the PMU after the GIC
      https://git.kernel.org/will/kvmtool/c/d4f6367f9a92
[5/7] util: Set exit status to errno in die_perror()
      https://git.kernel.org/will/kvmtool/c/6bb2256a59c2
[6/7] util: Allow die_perror() to take a variable list of argument
      https://git.kernel.org/will/kvmtool/c/88aeb551e3bc
[7/7] arm64: Improve KVM_ARM_VCPU_PMU_V3_CTRL diagnostics
      https://git.kernel.org/will/kvmtool/c/1cf1acf838df

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
