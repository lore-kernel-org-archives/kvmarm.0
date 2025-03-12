Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6311118FDAB;
	Wed, 12 Mar 2025 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741802966; cv=none; b=gUxuTEtXnF0xXBUg/FCXkeZ0u6GQKPW30f7F1+v6UZaZJD+Bw/Aso/B3ecQF7bRuS/YlsjQaDqcBKOYEY0XfQhexBuxsBzNrGiIZhLjH4mpzauvjOCaBaqmArwq/xgzLuokZFBu3VcMKWFD/zOsNRz29UxDj6Ai30rlBtOj+ZFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741802966; c=relaxed/simple;
	bh=zzZm4bP51vRe5DLXMdXQZoptqAsANoUXE7ZtekgeWz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyvFOVv+qakL7avF/hZgW7CH8p6OVTulNJt2W0eUTS7exPyqp0hp+Sugbat6drB+kimclxVXjDkOveh6UJsgH8sX9GiwKJOqFUSFrr6ELgekxjpAsld47WFVEKnsdErMxGH2tsRyc0otwQd9LsXK0aWBIK7J/qcFuJCLi6uoT70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C21CC4CEDD;
	Wed, 12 Mar 2025 18:09:23 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: arm-kernel@lists.infradead.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/8] arm64/mm: Drop PXD_TABLE_BIT
Date: Wed, 12 Mar 2025 18:09:21 +0000
Message-Id: <174180295545.4162360.4956385573664588446.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250221044227.1145393-1-anshuman.khandual@arm.com>
References: <20250221044227.1145393-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 21 Feb 2025 10:12:19 +0530, Anshuman Khandual wrote:
> Remove the PXX_TABLE_BIT definitions and instead rely on PXX_TYPE_MASK,
> PXX_TYPE_SECT and PXX_TYPE_TABLE. The latter versions are more abstract
> and also include the PTE_VALID bit.
> 
> This abstraction is valuable for the impending D128 page table support,
> which doesn't have a single page table bit to determine table vs block.
> Instead it has the skip level (SKL) field, where it will consider 0 to
> mean table and any other value to mean a block entry. So PXX_TABLE_BIT
> therefore doesn't fit into the D128 model well, but the type fields do.
> 
> [...]

Applied to arm64 (for-next/drop-pxd_table_bit), thanks!

[1/8] KVM: arm64: ptdump: Test PMD_TYPE_MASK for block mapping
      https://git.kernel.org/arm64/c/0b626b245c57
[2/8] arm64/ptdump: Test PMD_TYPE_MASK for block mapping
      https://git.kernel.org/arm64/c/f5e93819e2cc
[3/8] arm64/mm: Clear PXX_TYPE_MASK in mk_[pmd|pud]_sect_prot()
      https://git.kernel.org/arm64/c/dba954801004
[4/8] arm64/mm: Clear PXX_TYPE_MASK and set PXD_TYPE_SECT in [pmd|pud]_mkhuge()
      https://git.kernel.org/arm64/c/1601df9e366e
[5/8] arm64/mm: Check PXD_TYPE_TABLE in [p4d|pgd]_bad()
      https://git.kernel.org/arm64/c/4fa8a9c0fc99
[6/8] arm64/mm: Check PUD_TYPE_TABLE in pud_bad()
      https://git.kernel.org/arm64/c/bfb1d2b9021c
[7/8] arm64/mm: Check pmd_table() in pmd_trans_huge()
      https://git.kernel.org/arm64/c/d1770e909898
[8/8] arm64/mm: Drop PXD_TABLE_BIT
      https://git.kernel.org/arm64/c/50c2726654bb

-- 
Catalin

