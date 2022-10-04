Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DF8180
	for <kvmarm@lists.linux.dev>; Tue,  4 Oct 2022 21:02:56 +0000 (UTC)
Date: Tue, 4 Oct 2022 21:02:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1664917369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ZZPNPYzSVNBZuhnGB7CrCaQRRGaAvl+BMTJQ2z40OX0=;
	b=lNRjK2gvnV2+LQrnimaTqv2eY7/OBYwVSyLWUrjWNP6Ezl1kVhSJW1hOjl72cjEngiHhx4
	R1YdpsVkyvRMGPH1j6jssUyE0XuHysQ7bNmcA76PJFjJXCSAOuGVX6Vuo8JigZagfYRwN/
	5/CjJHfZqneXs66O33qwXrMToAJnw+g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: pbonzini@redhat.com
Cc: maz@kernel.org, seanjc@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Subject: arm64 build failure on kvm/next
Message-ID: <YzyfcIyudmSzTKx/@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221004210240.iN1C-ojbrMwSCo9LSYrJxuKt_SKJSYUSJE3kuwCkppM@z>

Hey Paolo,

Just wanted to give you a heads up about a build failure on kvm/next.
Marc pulled some of the sysreg refactoring updates from core arm64 to
resolve a conflict, which resulted in:

drivers/perf/arm_spe_pmu.c:677:7: error: use of undeclared identifier 'ID_AA64DFR0_PMSVER_8_2'
        case ID_AA64DFR0_PMSVER_8_2:
             ^
drivers/perf/arm_spe_pmu.c:679:7: error: use of undeclared identifier 'ID_AA64DFR0_PMSVER_8_3'
        case ID_AA64DFR0_PMSVER_8_3:
             ^
drivers/perf/arm_spe_pmu.c:961:10: error: use of undeclared identifier 'ID_AA64DFR0_PMSVER_SHIFT'
                                                   ID_AA64DFR0_PMSVER_SHIFT);

The fix has since gone in on the arm64 side [1], in case you want to
mention in your pull request.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?h=for-next/sysreg&id=db74cd6337d2691ea932e36b84683090f0712ec1

--
Thanks,
Oliver
