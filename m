Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190FE424D60
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 22:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784068843; cv=none; b=eHxInux1CJbE69+MWsv0aeECFrq2L21+JI8UCADAlDA8AoyU1Jq9hGj459Ci+nablrfTDVW8ScPJrteRH/1B7K8ws7iTpx7qNucVau/mLRgiCRdAuCE9nI8rYMvLECjvx44qATTL04ss3BvORXLss6RnhGjoTrp2cOlZweaoVtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784068843; c=relaxed/simple;
	bh=lgoqblNuB3ZXdfSbEhgeHOJiaAzwJ2NUaEi430cN6Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K++SQmo/2l0z/MRjCZzKgn+neXuZaC61Q6WxT0iaA4FGbps5Mxgzzbwv3e3f6lNCPGIS9RMFqUsddguTQ56w0tm7r+jr6J7u22wm5o2PY1JlgVL/HJWgr0CUQYOKWeVCJYwL+tk96nuJMyENnA2JD4P2pjsKpUCcQKFBFOclIL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17EC9C04A6;
	Tue, 14 Jul 2026 22:40:36 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 68F5B20028;
	Tue, 14 Jul 2026 22:40:33 +0000 (UTC)
Date: Tue, 14 Jul 2026 18:40:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kernel-team@android.com, qperret@google.com,
 tabba@google.com, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] tracing/remotes: Add
 REMOTE_EVENT_CUSTOM_PRINTK() helper
Message-ID: <20260714184037.2daf3246@gandalf.local.home>
In-Reply-To: <20260708075435.47419-4-vdonnefort@google.com>
References: <20260708075435.47419-1-vdonnefort@google.com>
	<20260708075435.47419-4-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ux4411ip4e8gupicefg384teix9wtjo9
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 68F5B20028
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19AI8xridY/1XYZQXkip1JQIP3/WAuCU/M=
X-HE-Tag: 1784068833-43235
X-HE-Meta: U2FsdGVkX18wrqZpiGZBLOb8lhHF/GZHPknmYHAe4VYwZ0no09tBevZMCXc2iSsoPbmS2y9T4taShAi2StnD5BWdS1taTJMCKlfsYfgp/BE6pKmA2fk1rfbczZ7ukY9K/xaAYC6UnreC9jrKK3I2c987LInX4fGjvAejfBHBFWjp4mDp9HQRJhuseBRcfrwISkYSmR9RA1yNf6EoVCud6Up4bI9Rx3KDFn4GABKoRaTmWC8bV9sCd0vAfXWCJwnvMQR5HP14TibnEJC1q1YL8WqLMc0IPwCEYpMFHthwTB+pS8SiOtHas6+QrnoenYYBKb5PW0Hi2rOKUpT7o39XqeVjLmKTYCrRhnpT6CjlzduS9ljYyteuFDxPjr2t2f1wOUC6F4yJWOZ4oHCn/tmcDw==

On Wed,  8 Jul 2026 08:54:34 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> The current REMOTE_EVENT() takes as a __printk argument a string format
> and a list of arguments, such as RE_STRUCT("foo=%d bar=%d", foo, bar).
> Add a REMOTE_EVENT_CUSTOM_PRINTK() where the __printk argument can be a
> function. This intends to support the creation of a "printk" event for
> the arm64 nVHE/pKVM hypervisor with a dynamic prototype and by extension
> a dynamic print format.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

I'm assuming this goes in via the arm64 or KVM trees?

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
