Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974E038E122
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 14:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773670156; cv=none; b=DbaPlYvJSmGcz6nmHP1uWu9qzBY2f0h32p1ORPoOHJWor6gKvVXJ+jbEs/cwRlLxFOyvYoxvMS+ZouxAHigSWsd2yx8jmwGKwwwjB88J3rHgbzxjnlaVce6ZEWr6iQc1bZz3YlET/PE1iJ/qF7ccYB4lZ5rRZMskFAMiP2VrShg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773670156; c=relaxed/simple;
	bh=RpFbwojHOvbMSgOHd3+a+CTJ1Hchny0ecmXUJbQasJM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVDH0xZAWKS0SG0dYzA2NYeUYxclrcsuQZUZeirdV1cLaJiluRTzf/Ix79p1mVUl0XcajBYm4jbxksOTuxHdROMUzuLWBcLQSxF3P1thjI2i9itaCqucBECJFCgWl8jZQyMnan8+Wu2lMWQHAOxIA6MNVLMLxQAP3YbPYiP0rBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E2871B7199;
	Mon, 16 Mar 2026 14:09:08 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 8A3DC2000E;
	Mon, 16 Mar 2026 14:09:06 +0000 (UTC)
Date: Mon, 16 Mar 2026 10:09:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, arnd@arndb.de, nathan@kernel.org,
 linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kernel-team@android.com
Subject: Re: [PATCH v3] tracing: Generate undef symbols allowlist for
 simple_ring_buffer
Message-ID: <20260316100929.5402a335@gandalf.local.home>
In-Reply-To: <20260316092845.3367411-1-vdonnefort@google.com>
References: <20260316092845.3367411-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 8A3DC2000E
X-Stat-Signature: dm8p7ceh157grqhgka97u1p15wu55rai
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+zV3OXRTLoPyZbswrwHq4NUslzfoUqPUI=
X-HE-Tag: 1773670146-435925
X-HE-Meta: U2FsdGVkX1/HGROROv7bq91DXMyArM6qJXchwwSY7dAsJCSrTpQ+01cKbmh0Ztf0CNL1P06fV34QflY6cSnWKr+Gfo/aU7ITb9zAPMASHJsVf8rTa6hVh2N39L6VFcGfe9i+P7kyTgeHIQ3AtTBidv6hsiZXdbdcMJX/uaXrx8AzMpqjYRjxojRu/odY0Nq1m27OZn5r1bDja28537z6zCftzIV7auOSRmv8MrkWva+Vob4R1Fp+LjE+ePjHKhQLoWHm9tQDKy57G9ddKHuTuIGBADjQgWfQufN4pFo1OthW8goKehu2lI+hc+8tAIw8BIerYQZN05dbRUpLk0qdXL8H1EG5AYpjtqXSS2OjmhLbzhzMrF7PWymIF7upu1juEBcaBQial7ZbujGcbGM9qxIUPWsVtw/6qJ4uglZDs24=

On Mon, 16 Mar 2026 09:28:45 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Compiler and tooling-generated symbols are difficult to maintain
> across all supported architectures. Make the allowlist more robust by
> replacing the harcoded list with a mechanism that automatically detects
> these symbols.
> 
> This mechanism generates a C function designed to trigger common
> compiler-inserted symbols.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Nathan Chancellor <nathan@kernel.org>

I take it that Marc will take this?

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
