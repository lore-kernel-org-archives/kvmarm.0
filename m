Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A66C183CB0;
	Wed,  8 Jan 2025 11:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736335828; cv=none; b=hhSkxlxPzT4xepM0eNIGV2OujpoSOtSkoNEChffQfet0GHX3abfsNg0fU07mvw6YkneHTv2OU7jmejZMNC3b9eB5lFTwQGs6fnEBLsJbCDT022A1lsGfOxGIarpP8LHfn5uZCxNLydBSpj+UjyZ2RumIubVVfvEwmuhDVx633hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736335828; c=relaxed/simple;
	bh=HUdFC7Hf2pRtsZcJxVfCVEoY1Puhr6jHWvWn6H9ruzU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AEmyjV7EDNd40n+C5owNK0Je8g+vYGeQSAitD6PSg2xAPIS2m2sCbwLqImJTbS20QPQWgv7sXKxqkqD6s/iExb1raR4PxKQU8ibnIjTNW4Q30jb4ygNKC/FPiVsmNVh8+lN3DoNNNyW1oggH17ElaTjjqWgGb/hMYQ6r/SG/N7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6MlDSua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6MlDSua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4DCC4CEDD;
	Wed,  8 Jan 2025 11:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736335828;
	bh=HUdFC7Hf2pRtsZcJxVfCVEoY1Puhr6jHWvWn6H9ruzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6MlDSuadJi/y6lmLBuKQ6Ir6CB8/QwDVNr+geV71IC0dG8K2RwbvobNb/N4kZ6gb
	 +ioUBzDYibCPRoQvDWCeuF7pda3P84eZrFQ0wIErfW5ue90uByGA9TtK5D+j5L5S8Z
	 +btE5UL+8aRZ2o7R5dz/ecoWgLA0JfVx0nit8jrjmnaJ8SPZI0fRlfhPOeMOvBXSVc
	 Gfki7iT0z3a7uyw0srndTodh3gDpRY30nmrsbp+L6m+WLLOuOox2Twlht1LHeR7anG
	 PC32MxhzD6INlRrWj3BkMLjVrJ6HahYbM1JP0zLFj6EhPrkM4qW5ynJqCiHtmnE6Sg
	 gUTKulsKRzixQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tVUGX-00A7ZH-Ej;
	Wed, 08 Jan 2025 11:30:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: will@kernel.or,
	broonie@kernel.org,
	mark.rutland@arm.com,
	Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com,
	android-mm@google.com,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Wang Jinchao <wangjinchao@xfusion.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	"Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2] arm64: kvm: Introduce nvhe stack size constants
Date: Wed,  8 Jan 2025 11:30:19 +0000
Message-Id: <173633579711.13074.2906615105628133376.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241112003336.1375584-1-kaleshsingh@google.com>
References: <20241112003336.1375584-1-kaleshsingh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.or, broonie@kernel.org, mark.rutland@arm.com, kaleshsingh@google.com, kernel-team@android.com, android-mm@google.com, will@kernel.org, catalin.marinas@arm.com, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, ardb@kernel.org, scott@os.amperecomputing.com, wangjinchao@xfusion.com, ankita@nvidia.com, andreyknvl@gmail.com, puranjay@kernel.org, madvenka@linux.microsoft.com, rdunlap@infradead.org, ptosi@google.com, bhelgaas@google.com, ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 11 Nov 2024 16:32:50 -0800, Kalesh Singh wrote:
> Refactor nvhe stack code to use NVHE_STACK_SIZE/SHIFT constants,
> instead of directly using PAGE_SIZE/SHIFT. This makes the code a bit
> easier to read, without introducing any functional changes.
> 
> 

Applied to next, thanks!

[1/1] arm64: kvm: Introduce nvhe stack size constants
      commit: 38f9e4b905a00047a96fbdc6cefe9ceb4dae34c3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


