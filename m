Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD13747D956;
	Fri, 31 Jul 2026 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785523916; cv=none; b=mY0r38koaRBSYDNfRA9/ZjjpkdGiEdaf8wgY9dqTnxUAhoKyl7u7GTs7Gc5/7vYSl6HMwhKxgm3MqZ7Fl+EsE2u3dG1SH/MekUKEizP49yYAf/G2vTOXzjFRcKnmd/KQvaHIbQbSszpbm0QjV9B3dsblCFCBjElxa9CxUwQywq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785523916; c=relaxed/simple;
	bh=wWWcZZ9OZWBatSMCH7bJn4j3ezHevjcCiOXdB0spbn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=koNiYUDIFOsXhtJZgBEUNx7qkU/o0wmqvlyA0fhLC/U1C5ZYu7QpWXvsjGxOBNxTIVR4vJ5XhIQCdiLdQFz4szxwrD+gWC/yH+V/SbEibmdQP4hSwZRaXjTQ2wMlfOr/+MPFZb6v9xLcF6S8sZF5yYeMnC874Siq/M4ZGOIGIy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJWUOkon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJWUOkon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805081F00AC4;
	Fri, 31 Jul 2026 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785523914;
	bh=XdiDIa8NUQSLfVGJe/NaVaWb+skzu3+raBFzb05hxto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJWUOkonsQEKYzJ17537pNVwZXUV/oYXelsRh6p0kHOmhjqlvBhu/GfQod+9O6ghz
	 mGJOjdoiu9YmpEae02Z2T8XxpnazLFW6ptzCdXC/0yQDhYhQmo1H0hJRF3zP/Da5YV
	 Nifh0g4sE23HaPGqkM8zSZxNC4iAkBYPjrMGyKr6UQOuhrWbX6RwDsc9fMSrJpoaAs
	 fKxHkkyT5+6a0F0hu7KuhaZ4aqp1Zw8/JOEfcDtyZhc86UCKVIKSQ944tiXzVtFTKM
	 mWZFTQ3BYi0rrXtHfY7m7C536KVDGrIUd7Qqgud/Q0mFZMawTIIh5SjYboFZm30TMR
	 qNkahoHalUQKg==
From: Oliver Upton <oupton@kernel.org>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mostafa Saleh <smostafa@google.com>
Cc: Oliver Upton <oupton@kernel.org>,
	maz@kernel.org,
	seiden@linux.ibm.com,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	vdonnefort@google.com,
	tabba@google.com,
	sebastianene@google.com,
	keirf@google.com
Subject: Re: [PATCH v3] KVM: arm64: Optimize protected mode with FWB and DIC
Date: Fri, 31 Jul 2026 11:51:49 -0700
Message-ID: <178552142327.30097.5768444825254040023.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723162002.3848054-1-smostafa@google.com>
References: <20260723162002.3848054-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 23 Jul 2026 16:20:02 +0000, Mostafa Saleh wrote:
> KVM opportunistically enables FWB if supported by the system for guest
> VMs, which allows it to elude cache maintenance for data as they are
> forced to be cacheable from stage-2.
> In that case, __clean_dcache_guest_page() will immediately return.
> However in protected mode, before calling __clean_dcache_guest_page()
> it loops over the range and fix_map/unmap it, issuing TLB
> invalidations, dsb() and isb() unnecessarily.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Optimize protected mode with FWB and DIC
      https://git.kernel.org/kvmarm/kvmarm/c/81b2d03f8c86

--
Best,
Oliver
