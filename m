Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08193486404
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 13:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206467; cv=none; b=KSurZA7QujBpl81Ad9+wzrb56J4Q0PY002LWJcavhP+kJ7NJovdM5zFGfZTRDPamPfQvlNlzzGbOBQ8Xx7y67MvSEW1M2wLM489DPd14pMfKe/SHLhmV3sBDkaxsOSVsz2KkkE9Di/Z0aS3J8pOTTcK0nRxxiaOBd2BVQbB/X68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206467; c=relaxed/simple;
	bh=SippWX+xoSkF20XXjc5MLFhzuRKSu+Feuro+st5YeiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dMtKeSKqb5Zw2BOP33eGQXIRi8Et+sedWVqN/CsSoy89v72+u6X9XDP1qW3qTjUIaCGcbyeKi9wnv7ZJeU9UidrX221X+1AhBKs7cQpAfOeRkn3ympeMR+TApr2JLmyfNdzb+Hmgf5M0eQ98vs5nq6On38FASqqb+G4pQC6ahw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XlhEXN9P; arc=none smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XlhEXN9P"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2a4fbc5586so307256066b.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 06:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791206449; x=1791811249; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h5zNn+04D/ADxwDdeMfBIdi2B0cMu31zTvDOOv1nE7U=;
        b=XlhEXN9P2Dwm/0qAUmRjdassNgUt8Y890f+kaiA1vK1HvwGIPMsLTEOKiMyxKjtnzO
         ppSppUTbYLRUEor9xMh0Q/al2D3KEmbMZ1BW15ZKUCzvVImXykumSmuZuQ38v0pyzj3O
         1hjWHrzbEqOGFQ3PzTBi7gg7nBSEfoQ59YW8v5eOsh+Yg6KjqgaL3zlDXKNUuCXN/b2Q
         GQEfxj3p5dWHV0Ni4tBTYjMnH9ByBCGxzVacTUqp4KS50Qy9KCVw4T0BQKq40KFkI74K
         utTHF5+6AJrBLtmyyS8fOjwNChpmo7qkABkXHasg0g2zCxMeC5rZ+6yK47dF6VH2TQ99
         0IBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791206449; x=1791811249;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h5zNn+04D/ADxwDdeMfBIdi2B0cMu31zTvDOOv1nE7U=;
        b=ZQp642AEWbKXTDFwlPnVKKBGMi5ALk56Sinl2gCTEwVs/uSofyizEISn7kurY+bmJ8
         i8e8Vl129Ud/qNw2c/+epKMEmw1i6ZiR18RK/VedqNYyzJnMKYivBWXmIqKspyRa4tj/
         2QI/2Vfzq9+ixBIviLTm8ZcINK9mz9t5lwxxdMvJI2qD3pKLGO9xQbHcBphsysarroym
         a5tHhD068EBbF2DiZ5wEXz9Efibr9DJNHv4Wb4cosYo+lTx6B6RmGQrj+kzXV50Evk0c
         DSvqqjbRPvf0Tfmc1Fm6IFHi7Xi4sJxamstbAKleBQvk1qCMtJ0G8fHNfGQ/3OwebWO7
         n9dA==
X-Forwarded-Encrypted: i=1; AKwUvBw7tAxvp28/O+Ba6oKDz+5xxtv6Xm3G3mr/SOizdcS2Hvw3EX34/meBHr7Yp+JrKej6/AEVdM0=@lists.linux.dev
X-Gm-Message-State: AFuF++kIuOqvM0BW/lIPgShBqIDcJr+FN8CIUZKYcW7fENqKO8JQQ+gO
	bpnJk8MtziR/LrKyobP8yn/bafMqH23tkizCgmbec02JfEJB2k3IXyZa
X-Gm-Gg: AYBFou1YffGHH3ylLUCa7R1BsTSEPmoVLuXeqWlzIKcl6naXc/tUa7YL8rvipxmw71C
	fJW0HOXeALw7oCNzu/ujhz4evHjMiGs6PZc9k73Qxylq3cTjJjxsY2mkvfnCJh5EUYVGCi8beFb
	zj56KQ3uS5MtjGHGfFvMHpGeWkMX0NylfD1b58nFnY6e+d1QLjAVFJO0bMWf/pyz9qPfE/WyMzN
	qo8qBxygfxLoSOL1XxNRjf8l37+r99bBpmK5lDU/v66F/P4sTMVcmtAadlo6fw8abYxtK3MpCWK
	YZkXU8B7sx4NpdCIow2du/brENmVnojK0hgW+B9JEHWx38O0LJj2c1S4zH3fITUP75aetK/rm7y
	DSAD+6KywI3j7diYSvGjtnbhzm6ih3ITB4Ii1nAi7mFgSfkSYriZwE/ypr9GcmK3nZhrUINP4iG
	rNgkOELNA/PDOO9YlsHx800jJ4SWfLmed+pRjSHt/U2VNuQmnvhqKXmWPsz6C2n342mcCgtdIUr
	Hue2r64q4x6BjJ4Aw3gMcV0D5a2VsOFTeAu5aowv4zQV3F/6SVXliT/gS83vLIAQADR4XQtpIp+
	NOvvI/Tyf3GzOxIcDlteP+swzHXFg9DQJP0=
X-Received: by 2002:a17:907:9614:b0:c25:8eb7:f388 with SMTP id a640c23a62f3a-c2e4ad13957mr911322366b.17.1791206448599;
        Mon, 05 Oct 2026 06:20:48 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3156333a04sm79392466b.60.2026.10.05.06.20.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2026 06:20:48 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>,
	Shuah Khan <shuah@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	x86@kernel.org
Subject: Re: [RFC PATCH 2/6] dma-buf: Add get_phys() to describe a physical run
Date: Mon,  5 Oct 2026 13:20:46 +0000
Message-ID: <20261005132046.30025-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a04f17cc-f59a-4240-81c8-29776eee3a2e@amd.com>
References: <a04f17cc-f59a-4240-81c8-29776eee3a2e@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/5/26 Christian König wrote:
> Well filling page tables by the importer is an absolutely clear NO-GO
> for the DMA-buf design, we have gotten down that path already and it
> took us years to remove this functionality again.

Understood, thanks for the quick and clear answers on this patch and on
patch 3.

> The problem you are facing here is that dma_buf_mmap() doesn't work
> because you don't have a VMA.

Right: the memory has no struct page and is deliberately not mapped in
the host, so there is no VMA to hand to KVM.

I'll post a new version of this series. It drops get_phys(), the ranged
invalidation and the guest_memfd dma-buf import (patches 2-5), and it
does not touch drivers/dma-buf, as you suggested in the PAL discussion:

  https://lore.kernel.org/all/c413710b-4c28-4ed8-88ec-aeb8c4482011@amd.com/

KVM gets its frames through the KVM-private guest_memfd provider
interface from David's series. iommufd gets them through a private
interface with the exporter, as it already does for vfio-pci. The new
version adds a small registry in iommufd for that, which replaces the
symbol_get() of the sample in David's series. The dma-buf is then only
the handle and the existing revoke.

Thanks,
Fred
