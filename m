Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6F2538D95
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 11:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790075817; cv=none; b=oxlk64W1o8YSNe2sb4vhZ2rpkkaTErUaxcQ2FxhNtpSaEqhp1OUN2DeVfhrKCApnHpgEWXhTyow4ByD7C2dvaG/BEFMyqn8mTd2xjr7jEIHyszRM/l1x/3k+KfS4I/bTLXmSvZrB1cGyCV6HR5SYwvnV8MvQ0wquf5WpiUC+J0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790075817; c=relaxed/simple;
	bh=X0vNJnpNs6hOMaqFf2v45FfFc3LhXGrCSlWSamftktA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IoPP70Y5kjqfOlHHkB8RKget7f5TCr6U3NUoMaz0uFgeD+ZBnQiJdgjeqOU57qZBFNMX3fb4MtdSuIN22gaWv+yNy1eSz5D63+vQztzFqAimftD3OzDaseqcv8p5SKkNPXxFt8xnSMZG3e8ETKo1Yzw8KUsEcc8UTHGCWtwEJ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GAC/5TK4; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GAC/5TK4"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49fcd86b8d3so28424255e9.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 04:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790075814; x=1790680614; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pz5XMLJlH/ksqI/ieLps3ISvdTbA9aZ9LqHyagA1F+o=;
        b=GAC/5TK4qXtJ7F1bIGdACwSaLwKgD6NcUIncfUj/3xHDXGPoDow1h1hYLrJNgbFCdF
         pLA1YM9/1WcfUt5ZjBRmnAEJEQVcoZu5YaRDKwBAhy8cuon/jDxTL7VrqdO1UocYFJHn
         mF3i1U6/OkFhCBzIpq8mlhLBdJ+8UjaF/iPHBtlCo4ByS5xE+w/c4iJRhHlHO9bXoqyA
         4q7qU04V1Y4KA3G1dq8OL/TvZ5FdoXPjlQqjensLKIY/kGiLNBxFPy1Fa6pNpB3s43Za
         P38h0q92I+pWQH02NwelQvsKchmtzxk4mlJOpD+nAjU4s4HhXjVcoJ/Yn1BAoW/QLl/J
         rr3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790075814; x=1790680614;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pz5XMLJlH/ksqI/ieLps3ISvdTbA9aZ9LqHyagA1F+o=;
        b=vZv7NEp3J/0xCdzEZq7WJee7nLP7McinYqo1hCYNiS5+r9xWYYehx+uAoDwRS3+2SF
         ELnVYgLTHqsI5Wk//iqmjrzk0g9H9zYLWQRQehMdcxUBRx24Z/OKhNMij1yEZyrkpNbD
         522QhdfsZAFDaGlLzJyc/Yu6ElYm5ZJNMd9hB+jzNlBN7w9kMVOQvJVbE49L04zh9xq4
         9TBK+Wb2IdGvSUEENeV0DUT/iO8+Ve4denWBRvzAP+q3dWbY9UfvstEjPYioSKgoM/Lg
         bItMnUjvHVlWsDJOl7OEhl7CHJSBF/7ylP7zUbkLYGnQ99Nnw/z0WstO2jvjpvTOD2hB
         Qxpw==
X-Forwarded-Encrypted: i=1; AKwUvBy3Gqcm1Fddz2k03Jgv5rBnbnPLm6KYh0JpHWEBNphMBaO5wah6zY9aK66nV1tqVVlm2sV92kA=@lists.linux.dev
X-Gm-Message-State: AFuF++ki8dbxGu/X6a4Ybz0VqBrZRIzQqMvOcHpCsrq0/NTa36kcHCh5
	9JXaUSQCv9ooPClSg7dfjvSunlLckpZtRAlBsaC/pQuBYRfNBSEiaZawZLjpkSQMnz5yjxW+BzM
	FPdqNaJ/MHBrTfvyJS3j6iqLgwg==
X-Received: from wmdp20.prod.google.com ([2002:a05:600c:5d4:b0:49e:8337:332])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b8e:b0:49f:bc43:9e96 with SMTP id 5b1f17b1804b1-49fc57144aamr246286785e9.8.1790075813829;
 Tue, 22 Sep 2026 04:16:53 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:16:52 +0000
In-Reply-To: <20260921165841.93EE21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260921165841.93EE21F000FF@smtp.kernel.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922111652.1024606-1-snehalreddy@google.com>
Subject: Re: [PATCH 1/2] firmware: arm_ffa: Add FFA_FN64_MEM_RECLAIM2 function ID
From: Snehal Koukuntla <snehalreddy@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Vincent Donnefort <vdonnefort@google.com>, Snehal Koukuntla <snehalreddy@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 21, 2026 at 04:58:41PM +0000, sashiko-bot wrote:
> [Severity: Low]
> Does the missing 32-bit counterpart for FFA_FN64_MEM_RECLAIM2 break
> FFA_FN_NATIVE() compatibility on 32-bit architectures?
> 
> Every other FFA_FN64_ prefix in the header has a 32-bit counterpart. If
> FFA_FN_NATIVE(MEM_RECLAIM2) is ever used on a 32-bit build, it will evaluate
> to FFA_MEM_RECLAIM2 due to the architecture-conditional logic, which does
> not exist here, and would cause a compilation failure.
> 
> For 64-bit exclusive ABIs like FFA_MSG_SEND_DIRECT_REQ2, the convention
> is to omit the FN64_ prefix entirely.

Ack, I will rename this to FFA_MEM_RECLAIM2 in v2 to follow the existing
convention for 64-bit-only ABIs in arm_ffa.h.

Thanks,
Snehal
