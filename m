Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150DF5FF12
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 19:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LhH9YYP0"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ca2a6f07b6so22551147b3.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 11:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701371790; x=1701976590; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y5pHXwknceWGmaj8OtPnr1WYaFoTOExKtqzqtLwiZ8o=;
        b=LhH9YYP0yh9dpN0htnTO62TybmDRNb05QHMVmrVsKoeq2L6LTelo5LeLhhvsf/77yG
         dsVyDYy7HxbhIeXy5dv0LHhCMuC21cg32VXk3yVhBukHV5tXWuwI7w/+Z/uuglKhJBsX
         Ws2VmdNPNdincaOtImjyIeKajFwbyQ3Tc+rQY1Xl4jhDAwqQ4f0dAs+RxqWp9LpK1+Wc
         tZKrw8DoPVSiDPdbD+VqcqCb19bco+hilcHZHwi3Rv5DmyFhChtlNsiGnbuaHD90eD8d
         btl0pK84SVY2cCIKcyN5PuYKnjifGtgANozTO1Q0bJON71osNggSUZiBLfrfMqKYIThE
         U2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701371790; x=1701976590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y5pHXwknceWGmaj8OtPnr1WYaFoTOExKtqzqtLwiZ8o=;
        b=NftYiQjTHqOGqnfYp6at8WxpTODZSbZIpQJRj30NmzmeWZHwRLH6AriQ5d898j5JFX
         KxpI3J9izUt4eoDYZJQFRVktw1oHkYXz6zwkAEHT7uiCfrE0c0lrdhM/fQdvCcV4nT5L
         dU3gBJhda61GDa7FTfmKBuVWJfhBEhrSN+wcUl/WUeyfg2OjcqFR2/u14Yn0oxUH56c7
         DDOEdKCQX2jDcaQrchuu9zi/7sQrT4Ocoy47FUBQNH8CLYDCl+BNJJVnu3ViKNsC4sho
         peANSlARx+EMi0dgR864RGfljuHLH021aFIkbD5SBULKaLYa+5frhZ4kaJFgd0jGyCNH
         4lxg==
X-Gm-Message-State: AOJu0Yxe2XXJ/YrGBY2eX0xfRaK3Waf/hL9RfL50JVN8dcQY32Sk+ewo
	nXAaWLWkFick3hEwxGP7mUr7zMPpz9I=
X-Google-Smtp-Source: AGHT+IGVQZH2hOZFevHTov9IVKBE8YAxCPoqEmlg+QCfshG7BGBWF+3pFeFyRhsJII6JOxcwz7vPkyXZa3U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2e87:b0:5cc:3d0c:2b60 with SMTP id
 eu7-20020a05690c2e8700b005cc3d0c2b60mr620993ywb.4.1701371789943; Thu, 30 Nov
 2023 11:16:29 -0800 (PST)
Date: Thu, 30 Nov 2023 19:16:28 +0000
In-Reply-To: <20231130182832.54603-2-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231130182832.54603-2-ajones@ventanamicro.com>
Message-ID: <ZWjfjAnZcomGa1Ey@google.com>
Subject: Re: [PATCH] KVM: selftests: Drop newline from __TEST_REQUIRE
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 30, 2023, Andrew Jones wrote:
> A few __TEST_REQUIRE callers are appending their own newline, resulting
> in an extra one being output. Rather than remove the newlines from
> those callers, remove it from __TEST_REQUIRE and add newlines to all
> the other callers, as __TEST_REQUIRE was the only output function
> appending newlines and consistency is a good thing.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
> 
> Applies to kvm-x86/selftests (I chose that branch to ensure I got the
> MAGIC_TOKEN change)

Heh, and then I went and created a conflict anyways :-)

https://lore.kernel.org/all/20231129224042.530798-1-seanjc@google.com

If there are no objections, I'll grab this in kvm-x86/selftests and sort out the
MAGIC_TOKEN conflict.
