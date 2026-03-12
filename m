Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B443B37B013;
	Thu, 12 Mar 2026 20:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773348011; cv=none; b=JOMloMQu7yTfnnt5c11Zk4poV1iY1+YjIdpHq9NIPkPywCZVtECeTY3vZOASeDqzbg3Tpi93FbU4QshvesURYN8XmQUZiD8S8B3pWl5jMpQ30+d8cmoVIILwMethwGBD3e+IdDyWvegRdXt6Ph7/zgG0KzWA9NgByAlLTH1QRhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773348011; c=relaxed/simple;
	bh=7h542fHy8Wlc9Q7iOCNi6a66KJOczbL9oTkHeuoyFY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYyG9nzZHeO5AX+QfTbHYSS/TZMiI4dFp1sVfRhJLrrHCeaicVOr+c//esurq19eFUiCXx6SR+IX+mRDe13pHjRHmmF9wBsFlKrO/LSMckOrERfUxpoIRJiPcewKi6oCoPfLnp5HtwLYsrK4Wvo+zzJlxAuqSD4YIGS1wqkVAYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BF5FhGmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BF5FhGmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4B9C4CEF7;
	Thu, 12 Mar 2026 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773348011;
	bh=7h542fHy8Wlc9Q7iOCNi6a66KJOczbL9oTkHeuoyFY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BF5FhGmi7OYWgBa6VYv3sPSwQ/uiXiEm49kPV98hatOIZIPGsvCnsrpByD7+CILqp
	 oggd7G+k3kA9Ntl8pVlLZafipno8P1uZXXt2q3rOKXLtv2eLoymW/qOnpkoKWMxmDl
	 XMMI4jygXx97HeyyxV0iVRgtgPgi4xzKpmpehTPOoObcFuV2vJvjE1R79kFE2YJE7b
	 70zHW2MrRAoHeWFmkgnxr0WmlByQI7aIPmCmUM1k+yoIz0hVYlK4zmvuV/Vpkt3j7i
	 apYQ4Q3/hOTaiz7CUQaCzwFoTQTcyzWlcoVp+F4bn7PO1GrrHeh4P0j+tg/V2q/6Wz
	 clL6kg2m6P38Q==
Date: Thu, 12 Mar 2026 13:40:05 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	jstultz@google.com, qperret@google.com, will@kernel.org,
	aneesh.kumar@kernel.org, kernel-team@android.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 18/30] tracing: Check for undefined symbols in
 simple_ring_buffer
Message-ID: <20260312204005.GB2747807@ax162>
References: <20260309162516.2623589-1-vdonnefort@google.com>
 <20260309162516.2623589-19-vdonnefort@google.com>
 <20260311221816.GA316631@ax162>
 <abJ_cm_yM3Q-99GL@google.com>
 <abLIslqIcVscZRFg@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abLIslqIcVscZRFg@google.com>

On Thu, Mar 12, 2026 at 02:07:46PM +0000, Vincent Donnefort wrote:
> In the end to unblock linux-next I have already sent an updated list of symbols.
> However feel free to send the logging bit, that is surely useful.

Thanks. I will review and test your "tracing: Generate undef symbols
allowlist for simple_ring_buffer" shortly (as I found more errors other
than the ones I described here) then I will base the logging patch on
top of that.

Cheers,
Nathan
