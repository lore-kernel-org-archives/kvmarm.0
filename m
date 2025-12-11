Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669882E2665
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765476701; cv=none; b=VrQJ1eKkUTPSpPOYGoW9Igg2bI5LScfmyViGo+MUs53qYBzNPdtJPfzXR2BUGCoB05g/ksk/to3RCjvBswC1x47VgEa1G6EkB+t4Cmvf/U8lM/aF/hq02cVFidSIsQ4MN+IiX2UrNycS6oGUApKfoFpDydSZ7PZeYBAR0wp8HC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765476701; c=relaxed/simple;
	bh=KI+8qZL8aV0efCR73pH0dhCbrItCpqY5HGweHERq0Jw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nRgEk2c+ko6iuaRVHFwD1BeHk9OXXwq5m8Bkpd1c0Bbk+8NVaO9840I2pbpU6sh14E64v8w7faEamcEMRTgTb+JhdImXCO+Y/fzeSaEufRez0/1+BA2/o1no2cwJE5aTJE/++nAIjnq3fNSMAUS9CA0RZ5m8lo8DkwdPSDUhp5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Un2K1Q/a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Un2K1Q/a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765476699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cy/rMqBjQbymJZZPm+KWkKxVQ55NMpIGDtN7g9mTntY=;
	b=Un2K1Q/apWi4ZjhRHSn88uVxMR2KuEiM7dWt7KsU24kmmsBU//8BfslrkHBzn+9Ska8RyS
	ZYq3ykuaIiZRfzJRIhHwJyzb/6LLcWgpyokiUeZ+ROEaXYz61ZlFnnXkRH4cC6vVaugTjI
	LyZ4mhfgDviwlFPwrF53Aqu9yNqEBcQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-yDDOVK75PBytmOMJWfEYsQ-1; Thu, 11 Dec 2025 13:11:38 -0500
X-MC-Unique: yDDOVK75PBytmOMJWfEYsQ-1
X-Mimecast-MFC-AGG-ID: yDDOVK75PBytmOMJWfEYsQ_1765476697
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47777158a85so4661815e9.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:11:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765476697; x=1766081497;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cy/rMqBjQbymJZZPm+KWkKxVQ55NMpIGDtN7g9mTntY=;
        b=r5KcOD+zGBGh7k+qSR0jzibvB6bYv6hIaMIuFlI3YN5Wkap6a1APp2aFn+o580tiiM
         qBx3w1KDt31TqSO0FSIUXlitPqfxgQReXCyUmzRmCj9nKfQno7xsh+ZSY7MKzCGFjBi5
         DCottKuLhjIrHsFD9FFLMHoKZ8ZTMoHea/OhraBYoSJPPZ0Z52TpUTFWRxNKQ61qhSXY
         nSupTQ45oNctG/qU2ukx0hJugkKRbAE0mCIg+0Iv9VnkHZNwfgmMs4M1nN+88dWHnyh4
         7Zs0iDwZrfvd8K0w4AeLgFtiChfVxOQLv+1CnNhh3Fl/kwaveuTE+CB/aaLKxp0JnQPI
         QE/w==
X-Forwarded-Encrypted: i=1; AJvYcCVzMp1fO3CNkuKU4Z86EI+2iEHy0uGAOtIyzGb08/8Yb1xzW6PttypZPB8ZaOHm4QwK59lZYvI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyx6BamHRrdca73yli/hHkw7MeocYRJE6OwohmUcwqf0nDLO2oA
	1VtsQ2rK2OnEi91ezXOjIZiU2k8BEU+NkOIlIr9M23weReDpNKvARH4XOf8fHysmnQpLl4s/LNo
	FSm3TeqCjfi9SNQpek2bETDG1JI3L2ugTylFrl/KIWfCW/ELRxYaMgE2VFw==
X-Gm-Gg: AY/fxX4VoSPEjt/pFkSNb3a4VjrINnZ5b1H2livhwOR9ddEGykjNP1EuWXG/V/9qUlO
	d7OnI3VKw5Vs3WsnSVCr3z3PUVTWseGfezvDpK8x8X+AXtSoCySD36aYQjqd1a2NVoF+10Adt+o
	UFIgUYr2zTd7QG6hTKLavOMCP8GousercE0vUWy8QXvp0jBYSefBr8YmP0gmdPo1C0Vcv9Szd5t
	RudWq7DhN1A5ExOzkW1cDed54Las9NIir5e/OER0KD8VIZMG3Yfa1TdCEJeOmG4GnSXJRSnFNJ5
	QOXY7eOIu+/h59u5/2KuQKGkEigZ93cbCjg/aem8eqiBrhnrV3FJBXiv+NBh3ur4MOV0zq9/85P
	45b7JOtvphRqJEuxxO1qCw1dAITFDME88m0q+X0dPluJI+IKQur5SM9Pfovg=
X-Received: by 2002:a05:600c:4ec9:b0:475:dde5:d91b with SMTP id 5b1f17b1804b1-47a837925eemr80416935e9.17.1765476696904;
        Thu, 11 Dec 2025 10:11:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFd7LSwA1Tw7awTk8rks0aApbnTxXvhb3ATj5j7IUdQb8VwjwZ9WpbdyuRokbJS/svQ10s56w==
X-Received: by 2002:a05:600c:4ec9:b0:475:dde5:d91b with SMTP id 5b1f17b1804b1-47a837925eemr80416675e9.17.1765476696564;
        Thu, 11 Dec 2025 10:11:36 -0800 (PST)
Received: from rh (p200300f6af498100e5be2e2bdb5254b6.dip0.t-ipconnect.de. [2003:f6:af49:8100:e5be:2e2b:db52:54b6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fa8b9b750sm6862862f8f.42.2025.12.11.10.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 10:11:36 -0800 (PST)
Date: Thu, 11 Dec 2025 19:11:35 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Jiaqi Yan <jiaqiyan@google.com>
cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, 
    Shuah Khan <shuah@kernel.org>, kvmarm@lists.linux.dev, 
    linux-kselftest@vger.kernel.org
Subject: Re: sea_to_user sefltest failure
In-Reply-To: <CACw3F52i_Yr+8Gd1=H=EMi7NnVJ8WCgMkaG1dSe8FD7PvOsW8w@mail.gmail.com>
Message-ID: <c44b75bd-bf54-0aab-78a2-89f448cf126c@redhat.com>
References: <1478ac09-8134-5551-13b6-c7be096262af@redhat.com> <CACw3F52i_Yr+8Gd1=H=EMi7NnVJ8WCgMkaG1dSe8FD7PvOsW8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CBd8Akgfxl5W3agLS_vaJZQFDDh1nEI7hohu-9qKERo_1765476697
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 11 Dec 2025, Jiaqi Yan wrote:
> CONFIGs seem alright to me. Do you boot kernel with cmdline options like "default_hugepagesz=1G hugepagesz=1G hugepages=64", or dynamically set up
> huge pages via "echo 64 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages"?

Neither of these. When I do the test is skipped:
# echo 64 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
# ./arm64/sea_to_user
Random seed: 0x6b8b4567
# Mapped 0x40000 pages: gva=0x80000000 to gpa=0xff80000000
# Before EINJect: data=0xbaadcafe
# EINJ_GVA=0x81234bad, einj_gpa=0xff81234bad, einj_hva=0xffff41234bad, 
einj_hpa=0x80241234bad
ok 1 # SKIP EINJ module probably not loaded?sh: line 1: 
/sys/kernel/debug/apei/einj/error_type: No such file or directory
Bail out! Failed to write EINJ entry: No such file or directory (2)
# 1 skipped test(s) detected. Consider enabling relevant config options to 
improve coverage.
# Planned tests != run tests (0 != 1)
# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

