Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34944582D4
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 08:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785833460; cv=none; b=COlOVUdzjbmhwhgrrH3HH6ZxvLA4f78eUFASRMhTauZIeW9SMU3SvC20UtGZ+XKtyEUcBXTHUcVuzrRF6MoF8UEHill73x0Ri3eEqUzRrEWUkP0g+SzG5Fpp3d7rtMFZxTJZMOB8n2EBtrVgmWaE6fOI1w4HZVB+CMk/rlcl0/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785833460; c=relaxed/simple;
	bh=dizy8BMrb1EtFWw195sX+m69N2yVavalVSh186iyFhA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WRdB4VGvH9AxtnwXfHIzT7SX+aeQRjdaAns9v8m4RB53fzjpQt0qA3sNHkLKH0XNeBXvLjMDQuwFgqGCKbBUCbtoPyrPP0eqaBzzJAOsVGEQv3xLLyC5pt0KnAKQnVv5yMtL7wuGOhNKt8uUOb+wHufv0r1x3nAIrUN/wl3AB7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uZBcMf8p; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uZBcMf8p"
X-Forwarded-Encrypted: i=1; AHgh+RrSuePhi6Zs0MH9msElP+ZNR172VHhRYsHB5Bdhh6JlJiGxWJ7XWwR4OKUDA1z7oehh6IUGDKc=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785833455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LEo++tWNX66vRUCbHgrcE/DoABgbXtbHvpdUx5myUAQ=;
	b=uZBcMf8pxB7aonO73GvtKwM+XOpDHWQz7Xk8UeDlTUbJwvKHTwaYnaBNw/1KNRQHXYHlLO
	h0Ayityk3JJmn3/Y0NB7dEvNyU8w1n0zagRd+S30XdzGfyVqTcwSa3Ipm14/CSV9U7gQJG
	9YBoEOIs4HuwrR/a7QJOw4nEgTLkO9M=
X-Gm-Message-State: AOJu0Yz+z8rPZaVmFjH+MRTAz4rJauz2cG04h32UnfzLXqEQst3NPbMI
	SJe46Ql6Q0h4MnMVTHu3hvCehTAgyCMY2YRuKM39icxWqI3+eUStOm3g9tigqrE4E7fXj5+ilAs
	C8QVnoWl5c99NWX+nloNdF80L9duciVSofDJBLdg8
X-Received: by 2002:a05:622a:1649:b0:528:38d6:71b4 with SMTP id
 d75a77b69052e-52cd5150f2cmr10989531cf.11.1785833444348; Tue, 04 Aug 2026
 01:50:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803124220.332248-1-fuad.tabba@linux.dev> <20260803124220.332248-11-fuad.tabba@linux.dev>
 <86qzkfaxp9.wl-maz@kernel.org> <CA+EHjTw1=xCPugZrmQ3nj1ddvCZ=vcZT3=KO_FMHB1USUTu7kA@mail.gmail.com>
 <86pkzyb7bn.wl-maz@kernel.org>
In-Reply-To: <86pkzyb7bn.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 4 Aug 2026 09:50:07 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyY+8-Cv1=dHg=4fbmOjtvA6+aY4yqV5uY2ev=uGJHEKQ@mail.gmail.com>
X-Gm-Features: AUfX_mxuF3k7WlOHdukcbNyPC8gFg_R9mHxire5WFqvzPcz3vuSQrFTruIYyFdQ
Message-ID: <CA+EHjTyY+8-Cv1=dHg=4fbmOjtvA6+aY4yqV5uY2ev=uGJHEKQ@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] KVM: arm64: nVHE: Check hypercall handlers
 against the declared ABI
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, 
	rostedt@goodmis.org, mhiramat@kernel.org, alexandru.elisei@arm.com, 
	vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	ardb@kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Marc,

On Tue, 4 Aug 2026 at 09:47, Marc Zyngier <maz@kernel.org> wrote:
> > I'm happy to respin with both of these, or would you like to fold them in?
>
> Oliver is in charge of 7.3, so I'll let him reply on this.

I'll respin in that case, make life easier for Oliver, since he
doesn't have them applied and they do conflict slightly with patch 11.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
