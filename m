Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7500032D0D4;
	Mon, 23 Mar 2026 09:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257827; cv=none; b=b9r6HE0vjZIGrN5L2C+v3fi3iW6SuFTJILBZBG9aTrolZ9osk26+Cp7bkuIMIQi5WNkfCZmT6LNM7QFJ6WXkoaD8xWpKK6y2Dpl5ne5vl8KXHo72UGh55rd6+q0jLdKxgG5T8ZyGUEkBIyiEqRXRNx+MlJ7WNokVWCoCr6gCPtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257827; c=relaxed/simple;
	bh=ITGv5rT47wvC2sbESak0rvs2OSCIJO4J5buuttHmxr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r3+ntkjqdae4SxAIAFf+ezDBWLojJctw/kS2otl/q5maFGpkEmr2rtHMCdR9DmrgEw1d2p3Iow1bzuf45gQ9vGwkkcV8nXAKBT9pjlI+QwSYmscWjVTKssR3P+61Nfj5sZg7YgAQ+ehVDoyHf1k3JyM33zp3+UHPev453Qi9mxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=suGiltet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="suGiltet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BD0C4CEF7;
	Mon, 23 Mar 2026 09:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774257826;
	bh=ITGv5rT47wvC2sbESak0rvs2OSCIJO4J5buuttHmxr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suGiltetbIUE+xZnfmNXWTyUelgX7LUszSV5ivHb5CZKNpMo/vXlirxvM3qyulq7e
	 gAXKBLyI6UqhA1tT1Vctz6tT//fmGqTSEAbkWWo0ragyr6RoO7lQhPJXaV1Iv+CCg3
	 cVzRWJsMqCItwUXWXwpV2nBqDTaQiduGUmVMOvDWLpBo272hRMLL28ltkAyY2ASQIL
	 MQurm/CEh9UlmRq+yOc1pUayAacaNgAsnl9TpRYaznEntCkjTA27rv3+OfNuFTdu9y
	 KADMTn1riP3dNkbSBSzlgLlyvB8y61NC7C7x1yOM/YJ06VS9xdgCJTOvIKHX2TV/Bn
	 RIoEPYvWH+IaA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w4bVg-00000004eUu-0vjV;
	Mon, 23 Mar 2026 09:23:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] tracing: Adjust cmd_check_undefined to show unexpected undefined symbols
Date: Mon, 23 Mar 2026 09:23:41 +0000
Message-ID: <177425781480.2859318.10854182770842769368.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320-cmd_check_undefined-verbose-v1-1-54fc5b061f94@kernel.org>
References: <20260320-cmd_check_undefined-verbose-v1-1-54fc5b061f94@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: vdonnefort@google.com, nathan@kernel.org, rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 20 Mar 2026 14:29:33 -0700, Nathan Chancellor wrote:
> When the check_undefined command in kernel/trace/Makefile fails, there
> is no output, making it hard to understand why the build failed. Capture
> the output of the $(NM) + grep command and print it when failing to make
> it clearer what the problem is.
> 
> 

Applied to next, thanks!

[1/1] tracing: Adjust cmd_check_undefined to show unexpected undefined symbols
      commit: 58b4bd18390ec3118d8577e19bdee0d01d40c31e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


