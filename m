Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EC6430CC6;
	Mon,  6 Jul 2026 16:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783354793; cv=none; b=TX7Mryze3Ing/hjPOo38BOcGH7f2g85nHF2mVw/rcrD8t3XdRteEuFrTzXFxynvYWn5sN4I3yhOZIwb6cDxFlAMSPUak/ez+6509KkFhAfmor9svWYfr/GnVzeCt7KUfLzXCBL4+8LkQ5WtVhfDGn0DRRV45qPl4uJb5Pz/7akc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783354793; c=relaxed/simple;
	bh=yNynhv73lPjFhZ2zYWziX++ZgYwP7E2kLabCHR1uk04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=llyEuCdyPb7KivTP7201X0upDsPZ6jTraUYRM/LGBSwWUvbGFnQHRR+fSWmCc1RjIQ8fRIyYurtVK9EzaVGxkyp3QZO0ev5xLCXuiP3HBdIKJtoACG3t9Sng1HYapZsbUx+CE+x6j1dLYMYSvBYDpYNWd4FYD41BzWp0pWaekq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3zTKPcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3zTKPcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4611F000E9;
	Mon,  6 Jul 2026 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783354791;
	bh=UYBpy8zRzkofUshdAnxZ/FWgmq9S3pQn543IzDx2MdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3zTKPcjQfumojhu8OA6gDYeOViJPi/Jg2c8ZbHHAEksn5AxKLYy0V8fhwjhBH7Cy
	 HG3syJBi6dXVfkFn7Fu799XT/2AJQVqxe9I7OXfvC31V0+3AQsBE1ITqDDvlrTlqUz
	 yF6SnkfUlSYaqGh558iIyinO24Qfx3M0/ts61AV9Q+RqZcddHSZhwvs8GjaR/olPAq
	 SDIJY1ksKjOsKWMDF7o1NVb9yOImMvFNmy9siqKdgPcizEl/BX3BlN1UIjhRPNTtjs
	 kEhR59fV5JxbxUaWWwI/QtmbxX3uVz8/+t7GU0tPT6I5HTo+/RT/cjAx8+1p7TXz8f
	 Vg3VGOmFXMjbQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wgm2v-00000002241-2h0s;
	Mon, 06 Jul 2026 16:19:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	Victor Kamensky <victor.kamensky@linaro.org>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] KVM: arm64: Fix and test MMIO sign-extending loads
Date: Mon,  6 Jul 2026 17:19:46 +0100
Message-ID: <178335476045.1423186.16967081834090661030.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706115522.954913-1-fuad.tabba@linux.dev>
References: <20260706115522.954913-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org, christoffer.dall@linaro.org, victor.kamensky@linaro.org, tabba@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 06 Jul 2026 12:55:20 +0100, Fuad Tabba wrote:
> Changes since v2 [1]:
>   - Patch 2: dropped the second make_el0_accessible() call and the
>     el0_be_loads_end symbol; the EL0 code page does not need its
>     user-access bit set because it is fetched, not loaded. (sashiko)
> 
> Oliver's Reviewed-by is on patch 1 only: the code there is unchanged
> since v1.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Fix sign-extension of MMIO loads
      commit: 85f56708a443ec02a290878f00d79a1ff5110e41
[2/2] KVM: arm64: selftests: Add MMIO sign-extending load test
      commit: 65a38ddeaeed1a962bc1b4ca03c98201c877fea5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


