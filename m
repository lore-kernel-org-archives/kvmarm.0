Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D3C330648;
	Tue, 17 Mar 2026 09:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773738229; cv=none; b=GOOyj48gs1JT3XQ+Q0dM+dqNo6M6XJHAfD2pBvZAaDbY21WTx7XKlgbJvIyvGak/OBJO5WG3d/KARcBmjuyqePl3gslAozSPC2hZf/wc8ntiGHeZCoJH+7keb1sP+9JREKZSHejxIaBZDNBRWany/UV/gVafqd+JbeYDxqVSAGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773738229; c=relaxed/simple;
	bh=m9OSqq2QbCO53oiWKEDbQx3vm/A/a9SDYbYqBvBQBXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sJSD1yCOM9RnAnk38RBzpcxJL1oxW59ePjdLuelEkyJFj/7rjEIBXvsyhDh3E5OPl5wf/rJahSEq05y1dtpZ+MRKEetqxH+gRAf1CkZeGfIVIdLIyF2I4Y0bV1RZBurDHNGuhG/Y6vwLUK17j0zB1rDL7Py2GFW97YdfYzwwX4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlgWk6pQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlgWk6pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D22DC4CEF7;
	Tue, 17 Mar 2026 09:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773738228;
	bh=m9OSqq2QbCO53oiWKEDbQx3vm/A/a9SDYbYqBvBQBXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlgWk6pQFJpFk0+YSZn+EW7ggBR3q5Yf9wuAWX7a65rv6IODljtRO3GuVh174PMk+
	 Dw5990kYL1Bx5312yUupHTmIuV63ChDPuucLeUYd+UYvJYzEE9P4JuRFHxQJBCjeXz
	 3jornnzPpVVmOwnf9NBP72/8u5P4LIV9SWRKqeI/6AgW+E/ilDSb65E+PplVXQ7s6f
	 hV4b3UZSiM4zgkwy+rz12e/Q/0cNZEZI3ZztTKl6HgE2gdGSK8Y3ZwmYq1PXRiKq74
	 P9eUR7VkBsh2ugEEKX2LukzQrhix/F2Lh51SqbukUniKydaye/jWMtvWxvsrkkv4zT
	 5FacK6V+G05ag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2QL4-00000002kOd-2U1B;
	Tue, 17 Mar 2026 09:03:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: rostedt@goodmis.org,
	arnd@arndb.de,
	nathan@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH v3] tracing: Generate undef symbols allowlist for simple_ring_buffer
Date: Tue, 17 Mar 2026 09:03:38 +0000
Message-ID: <177373821123.1873406.9990041733159949916.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316092845.3367411-1-vdonnefort@google.com>
References: <20260316092845.3367411-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: vdonnefort@google.com, rostedt@goodmis.org, arnd@arndb.de, nathan@kernel.org, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 16 Mar 2026 09:28:45 +0000, Vincent Donnefort wrote:
> Compiler and tooling-generated symbols are difficult to maintain
> across all supported architectures. Make the allowlist more robust by
> replacing the harcoded list with a mechanism that automatically detects
> these symbols.
> 
> This mechanism generates a C function designed to trigger common
> compiler-inserted symbols.
> 
> [...]

Applied to next, thanks!

[1/1] tracing: Generate undef symbols allowlist for simple_ring_buffer
      commit: 1211907ac0b5f35e5720620c50b7ca3c72d81f7e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


