Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B762D42640D;
	Sat,  3 Oct 2026 12:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791029397; cv=none; b=WZJSQRD2x/S4wIDfGimtePTXoIEicIXEe9aG9is9BcnCqmMM88qiGWJRSY6kKkPjfulJLZi9d5cUFBOPhnSevxIcAprYcfDWSvLZiUz4+hZWzWHOIE+iM0CeNNkLNtjpKPBLCTRS8FcM0iXTh66zGKo9Em+cBATlW6AknEM8nTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791029397; c=relaxed/simple;
	bh=ydLdX1bv8nacsZrCEgcW2BgJb+FqrrvCBTThW2o2HQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aqZsHz/Zn7V950rT6AuluDjsCIzUOMJqZWX42HnJy3/UntkbKeaeDwE0huU0xZSKgR5VCoQ4WRyP+Dnn+aEM2TRA3UvsmtTvzuQTve7pbj7upH8MlX04JnrFZ6J2M0zWIi1i9DjeMsSzmcT5sv0fVlQUxXH5Odxfg1MtO+Q6Mu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUIHszFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUIHszFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4497B1F0089B;
	Sat,  3 Oct 2026 12:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791029396;
	bh=JGL/QMkXhGp4RMJCeorSCQM1mqxZY8KjXd5vjpbYZ8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUIHszFBWdJL7uEiD1n2erTbHkaqEp6cI1LuyHBgc2W0BgH2BkEoEpNdeEBqKaanV
	 kVGU8UGOH4N1NhNOTGfTSeCioS/qjrgiFWd0+UoL2RdBZtREfaHpCpOhmJXHdwRwqg
	 h7KiYD5lkRVB+sXhgyb6CgvkZrRUOxtP1qWU+VkYsrwpE7WJBzuAvRb093gRVceCg1
	 VjhMEH3QifZ5E0sdPbWGPAhg3x3Z/l0QG40rozyy0ZkhkG/naKDYTB6rm4m/djEblT
	 m4vnXa+mnEdolmX8hrooGIVRXgA3sK+f8Fsb9n5x/oeDHus+yh/LyESjxBVIzzyGr8
	 5J3wYSYyC8aNg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xCyYs-0000000GWg2-1VO1;
	Sat, 03 Oct 2026 12:09:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 0/4] KVM: arm64: fix VGICv3 redistributor rollback
Date: Sat,  3 Oct 2026 13:09:47 +0100
Message-ID: <179102937974.606863.14966815402527336266.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831081005.41346-1-kmehltretter@gmail.com>
References: <20260831081005.41346-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, kmehltretter@gmail.com, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, eric.auger@redhat.com, christoffer.dall@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 31 Aug 2026 10:10:00 +0200, Karl Mehltretter wrote:
> A failed REDIST_REGION write can unregister redistributor iodevs while
> leaving their assignments cached. A retry then skips those vCPUs and leaves
> their iodevs missing.
> 
> Patch 1 fixes the accounting when an individual MMIO-bus registration
> fails. It reserves the selected region slot before registration and undoes
> that assignment on failure.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
      commit: 8a88a46b86ca3dbbd24522760d29edfb3f24ac2a
[2/4] KVM: arm64: vgic-v3: Roll back assignments from the new region
      commit: 4dbeadeb6ac44819d0f301c1403552695ecd3ca5
[3/4] KVM: arm64: selftests: Pass guest code to vm_gic_create_with_vcpus()
      commit: cb5e17e05bfd80a15c36a51a0386f566cb27e73d
[4/4] KVM: arm64: selftests: Test VGICv3 redistributor region retry
      commit: 74c8641bf0b5412b064cfcfaa3603e387aae4b21

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


