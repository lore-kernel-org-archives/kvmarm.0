Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4672846AA94;
	Mon, 14 Sep 2026 12:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387450; cv=none; b=aAx6w7geG6nzcwNBJazg7PdZJqMTam7f9cVXNUw7thVtL/8USGLgIH1cJA8vxGoglFDihmW2V4rJxekWGKqF0bOql9iTCmGa/4jFKuBaSQqaar+pHJZaMJ2iJQFDQSYK4ur2q9tmuJH8TaANoIObvJBJ+MCTeCLe6HWfso5l6m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387450; c=relaxed/simple;
	bh=gGDcySCBWBsVEpf5yhUBBIVPBCipAn8yEt4ASpBQzqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ahxrAKebUV/9xFTyhO25nXoX4PXkm11+EYkJCllqI/HOEIH6u+sBGFz2zgOF5sZ4Gr1Q0Be8JOa7Nlg+USGFZSi+3nLqa93bs72Fq20q4MinlZh+7LMPKWWA3pKn3QG87DSjB3bwuCivnO37nohCsKn2pOITxyxv3biwitlxb2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUiAZs4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUiAZs4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB261F00893;
	Mon, 14 Sep 2026 12:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387448;
	bh=oOLL1C5eie9+kGSnrAOXLT9ogy6qmnrvuuUUQyZnKQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUiAZs4ZCmd3/F3nbnio15LpDvz2LTIPuBEeUhcKB3CO+db0M/lD/JNFUQAhppwzb
	 ZxqLMD6s4KoN2nOiLnBxHAA4kqLSJJIvUSdl980qtJIylOtS0pPPCvzMoVAFqUKWZb
	 s1Uptynq53GXx+MLNZRjKxhUmIwFEpA3ltvauIKC7++8k4IcBC4LCq4reo5HnSWy8y
	 2jDeIQ6wyPjS7cIoqO2oAAIOqdAog7jkx3mdeSwsfrbPdO4i8T5HUaiQcL8GKrJm2l
	 FjQpXImE+2RhiS3EpiY00ZkB7uOzzdJAkzqeJnMTDAjr+ot+mUxioEXMXm6bn18XnO
	 cpNzCXynZjt0g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Pq-00000008bDc-3qgi;
	Mon, 14 Sep 2026 12:04:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
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
	Shuah Khan <shuah@kernel.org>,
	Hemanth Selam <hemanth.selam@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/3] arm64: fix typos in comments
Date: Mon, 14 Sep 2026 13:04:06 +0100
Message-ID: <178938739476.3215146.1948187248567448062.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907044434.4682-1-hemanth.selam@gmail.com>
References: <20260907044434.4682-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pbonzini@redhat.com, seanjc@google.com, shuah@kernel.org, hemanth.selam@gmail.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 07 Sep 2026 10:14:31 +0530, Hemanth Selam wrote:
> This is v2 of the spelling fixes for this tree.
> 
> Changes since v1:
> The pauth.c change is corrected: the doubled 'is' is a misspelt 'it is',
> so v1 deleted the wrong word.  Spotted by Fuad Tabba.
> 
> Only comments change; no code is touched.
> 
> [...]

Applied to next, thanks!

[1/3] arm64: kvm: fix typo "synchonized" in comment
      commit: e9fac0fc75abadefbbfbcf514f5d3b6e3d8c1196
[2/3] selftests: kvm: fix typos in comments
      commit: acf96ecc5fb6a802928a0b71bcded2addc3e58d4
[3/3] arm64: kvm: fix typo in pauth.c comment
      commit: dacfc40976411dfa97efbe1cc21650049a391eb7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


