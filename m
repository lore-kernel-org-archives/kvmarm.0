Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD8B23B1
	for <kvmarm@lists.linux.dev>; Tue, 22 Nov 2022 13:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32261C433C1;
	Tue, 22 Nov 2022 13:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669122683;
	bh=GZf60zaEOFSzAKJZHykfex+a5j/lCDpj8qT2YA+uWRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgF3z/VWKUADfWrfbCT71fZ/RsAkF3uEgIbQn9uby0wG868IaAZ/M2RzdwBD7wo5R
	 lV/U7lmlWOoF1NzQGTqYfe+Z4u9ykknQSuBS8q6AsZqpoVG0ZAwphrl6xEW2FJpyPa
	 K6fZn6MJhSzXwrAaqihhoP7Zh0u/+0HogJZThjkH5i2zW1oAZA0bpZ8xCykW4eyfYx
	 MLXD8qgJdxX//a4RVkPmEoOgSJ3XLzdtyvyDkqXKg3IhAh99pr7+6hk2LB1hBllXL2
	 j78MFLZtanZiIV4UBMJAp+rQe8i5hbfCq6g+tIRNPxgZfkBnLCW9ILJViOiz2qvm4J
	 Es9h7VGLMedGg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1oxT3Y-007rhv-QS;
	Tue, 22 Nov 2022 13:11:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>
Cc: andrew.jones@linux.dev,
	kvmarm@lists.cs.columbia.edu,
	bgardon@google.com,
	dmatlack@google.com,
	shan.gavin@gmail.com,
	zhenyzha@redhat.com,
	catalin.marinas@arm.com,
	ajones@ventanamicro.com,
	kvm@vger.kernel.org,
	will@kernel.org,
	shuah@kernel.org,
	pbonzini@redhat.com
Subject: Re: [PATCH for-next] KVM: Push dirty information unconditionally to backup bitmap
Date: Tue, 22 Nov 2022 13:11:17 +0000
Message-Id: <166912262441.898230.966116891061492784.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221112094322.21911-1-gshan@redhat.com>
References: <20221112094322.21911-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, gshan@redhat.com, andrew.jones@linux.dev, kvmarm@lists.cs.columbia.edu, bgardon@google.com, dmatlack@google.com, shan.gavin@gmail.com, zhenyzha@redhat.com, catalin.marinas@arm.com, ajones@ventanamicro.com, kvm@vger.kernel.org, will@kernel.org, shuah@kernel.org, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sat, 12 Nov 2022 17:43:22 +0800, Gavin Shan wrote:
> In mark_page_dirty_in_slot(), we bail out when no running vcpu exists
> and a running vcpu context is strictly required by architecture. It may
> cause backwards compatible issue. Currently, saving vgic/its tables is
> the only known case where no running vcpu context is expected. We may
> have other unknown cases where no running vcpu context exists and it's
> reported by the warning message and we bail out without pushing the
> dirty information to the backup bitmap. For this, the application is
> going to enable the backup bitmap for the unknown cases. However, the
> dirty information can't be pushed to the backup bitmap even though the
> backup bitmap is enabled for those unknown cases in the application,
> until the unknown cases are added to the allowed list of non-running
> vcpu context with extra code changes to the host kernel.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: Push dirty information unconditionally to backup bitmap
      commit c57351a75d013c30e4a726aef1ad441676a99da4

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


