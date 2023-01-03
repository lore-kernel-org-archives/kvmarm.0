Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0202D8F47
	for <kvmarm@lists.linux.dev>; Tue,  3 Jan 2023 17:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60B2C433D2;
	Tue,  3 Jan 2023 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672768560;
	bh=750RGcgvnOqRYph+tllxdT2OI6N1Psaq7uioRV7sCFQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HnJGLuIacRlg0d6VVu1UlaA8cUKJS4NZ+K6d3KEISXsLd9pb/qV/raOsDtAv4CNrl
	 HGO09/VaegmDHcSFhzQAKmLxNmzIpw0tce+QjXcl/prdRyn7KtcqbOETisTvJqcNZp
	 waewf8RLm7oABb8qXria1phnVJFaAVVU3d0OwkvcWMeR48I8BUuHH/5UbLUV4TCU2A
	 9wbrRl4+YtUk0XTJamRd10g3WpRMzAG6a8TqMFS6rqCg6MTS5HmFn5Wajn14yfqDAn
	 oXtOx8mpeeOkDZhNLoBrXUzEy6yY0VEahU88MisEDytEckqgvR+oC8C0LcUQZQ4Lyf
	 a1qX1VoVbTW2w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pClW2-00Ga64-CV;
	Tue, 03 Jan 2023 17:55:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: james.morse@arm.com,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com
Subject: Re: [PATCH] MAINTAINERS: Remove myself as a KVM/arm64 reviewer
Date: Tue,  3 Jan 2023 17:55:54 +0000
Message-Id: <167276854454.3239244.17038500511944981489.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103120736.116523-1-alexandru.elisei@arm.com>
References: <20230103120736.116523-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 3 Jan 2023 12:07:36 +0000, Alexandru Elisei wrote:
> Haven't done any meaningful reviews for more than a year, and it doesn't
> look like I'll be able to do so in the future. Make it official and remove
> myself from the KVM/arm64 "Reviewers" list.

Applied to fixes, thanks!

[1/1] MAINTAINERS: Remove myself as a KVM/arm64 reviewer
      commit: 386767035098b10677861d8268501a874e5593c4

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


