Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711180;
	b=N/lbWGxijyOLv8FMqtzBId1e99lZduMbeq0oCXYSr0GqeTuUApe/N4DuKVaPBW9uudni
	 VHrPSLogxATul9K8woxfW54yUCu+hm1Mlp2a/5sKsSdpLKYFP66xx3PBH4b/yHuYVJLDv
	 NAbcPQiAcn/lNbEd8B1ilNzc7RbLv9ZR8ZWBhFHPOKNcQ/XGdJenFwQ3uFsbl31vj8amo
	 Kzku3yBnXsYhIdjXrp70eZy0q3G7FWaXvnm7k9WXM01I40KfQ9LmyIhB+BC0rrgwOzqIy
	 oEdCbEyenNIWTxCT61cRwVnyZUqrJmDi4TbdZdwGd72nc1Co8fO6MXXikclu5zTokow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711180;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=tKorxSMbW3M4sLggkFqZvWEBwtgZOVvak8DiFauAu1A=;
	b=ePWR+8KCNhKSN/i5AfLTD8idD1jt7NrQ1VpBSjiFiCheOmHoTuSgdYPLmgmvBn85Ek6U
	 ihhWUntZfMyRrsmirPf8U5BLIqO7qdPk8gkPWyt7z1s4XKjTluHiwJyM6BplZgmnDiPNC
	 DrPXbJq7SQTb1Su4V4EU9Ssdv1h2wFYsrcCYaPHgMeRMhZDOfRN8Ocmlff78AiqWBVonO
	 1Zj8qXD4QIRu1YX+dvnkDFy4f3GJcH3L9BVMy2yOMzYXtso8n/b+zRpV0hLnA9rO3OLjs
	 kwlIcOIg88p0ybQKNxL5DGNu9Xqz5pR9kuehyjKANzqka1r/xOt9/WED6oXgio9HTmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n1vxv0t8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26370606D807;
	Tue,  3 Nov 2026 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n1vxv0t8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F173E1F00A16;
	Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711180;
	bh=tKorxSMbW3M4sLggkFqZvWEBwtgZOVvak8DiFauAu1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1vxv0t8pJ0QvtIlgvt2ukdoeT883QA4GXA2BhiAsiHpbfU9gf2YCWiELUjNzd55g
	 6Hh20a2TJQQPIGqdhO9J6w0tLXwgvd15wE+OMJB4qlWhp3nCFR2tcVtao2qgxs6wT9
	 NikpiWUyqA3pBp+Kfrm9qLyo/VKEYJ7pGrWkvjUVK1xq4oMfjfp73Ah5sW1DOeKyxJ
	 kCelGuYU8HTbVjGzQjw/6Wax6Zlz/nknGsdCdJvEfdREgcJlkEaUH5n/PnU6bascie
	 2w3yCfb6j3SBlgBg6iaiyZL0YbCOc9QdaapafqwAijVQtSZMlIIgnPlXt2hUUZCsGz
	 46+TLiUcCcOVA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDS-0000000ATWs-0vxI;
	Tue, 03 Nov 2026 13:06:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Price <steven.price@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: arm64: Fix stale MTE tags reaching a guest
Date: Tue,  3 Nov 2026 13:05:33 +0000
Message-ID: <179371111264.2844725.2216259269329758038.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261021110700.493315-1-fuad.tabba@linux.dev>
References: <20261021110700.493315-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, fuad.tabba@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, steven.price@arm.com, yang@os.amperecomputing.com, david@kernel.org, ljs@kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 21 Oct 2026 12:06:56 +0100, Fuad Tabba wrote:
> Changes since v1 [1]:
>   - Added patch 4, mte_clear_folio_tags(). (Lorenzo)
>   - Moved patch 3's sanitise_mte_tags() call into the
>     kvm_pgtable_stage2_map() branch. (Lorenzo)
>   - Patch 1 loops with folio_page() rather than reusing page, and its
>     comment now matches patch 2's. (Lorenzo)
>   - Collected Reviewed-by from Lorenzo on patches 1-3. (thanks!)
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: Clear the whole hugetlb folio when sanitising MTE tags
      commit: cbf47fe57a568f178ac55176d98a13caba1d8598
[2/4] KVM: arm64: Clear the whole hugetlb folio when storing MTE tags
      commit: 62b9e1f75a3c39cfc38b3950bbad017ac5f95bcc
[3/4] KVM: arm64: Sanitise MTE tags when a permission fault installs a mapping
      commit: 249e053eaacb2959794a5ee3d27737063f4e3dad
[4/4] arm64: mte: Add mte_clear_folio_tags()
      commit: da9f24dc43361b1cdcbba2fee7b90f4706819fa7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


