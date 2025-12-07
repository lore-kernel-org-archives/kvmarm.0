Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F33208994
	for <kvmarm@lists.linux.dev>; Sun,  7 Dec 2025 03:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765077173; cv=none; b=XVz1k7OSYmm8qnkIZ79jB2unJ0DQwNFqKDrUhSmQoPS5MPwl68iYEgQBVATaq5cOIY7uXUZUcnLJIN+OV6GDDtG2ejo1P5ddWpcbGT2ayaWjEoDmzfQ9Vnq5lOUtaIo50WWftRZUm6IvK+SHmigYWSw5UlcDQPyn0EL/BTwfGJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765077173; c=relaxed/simple;
	bh=WotXdY2S46V6EWUmhoIs7cQiM+SwpVn3irRrTAXhRds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dO18W8/Wj2W+eYHvWQGz38cUXHeg0avmrqkJ98/OojVN9kcQAc/G4DRuBK09/WPWIH4uMPlah0q3pJSCUT8Qioer61WP5c6hbo4O+VgoStXZlxjPcqiYKDlyayssoRQ1MvMOW9utpD3ltfSFdedi9PbuFVUvtpQGMzHIVzk4NMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jSCOWPfZ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jSCOWPfZ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477a1e2b372so27348615e9.2
        for <kvmarm@lists.linux.dev>; Sat, 06 Dec 2025 19:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765077170; x=1765681970; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVjvCRDiLMRUoN6KdVSryCZbii8x/leb+gzOibV+bP8=;
        b=jSCOWPfZb3JM3SFx85PiKyLVgmpXoh1Os1WD954JQZSAOcYOcnATJ+s6jDSxGEWYC1
         pcyL1ecACMI0X/UQyFeaYwcJvgY17ZBnUjdP53VcxrzmMf4NVziolC8NimQpC98TlFZq
         KXWZ/AjiUtBKuEoLSCnbiJHwq3ATDf+Lyc3MWbMvvvwBc/TkI2qtmNOhjsX9eWDVR0Oz
         iGvusVQ+hRgGDmv+4hvrqPL3n+qBbmTDmrXL8oiPk667+PDqu8nbES4Z2fLKaF02FnSE
         W7H/Va89X2zrXycb6l7pZ3p764s/wlin2W7Zu9S4qy1PGt7ElisrIR+ZRW4Ely4OP8hE
         6Ncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765077170; x=1765681970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVjvCRDiLMRUoN6KdVSryCZbii8x/leb+gzOibV+bP8=;
        b=LrEkvz4mhJVW4yhOyOYqjXc3QwDMUMqYPVZRRPjFAAUXeUeQIFYLAkmfEDyfRaOmDp
         K0xAcr2l+zsg657eS3DK1ersv8ABtS/Fqce5GIzj+WFijc7Gq5E4WRQaf4qvIfEomPHp
         MkU2PrJiHSR/BGzgGD1kHhacvFRpqCQqn0mH7srKaoEF/FBf5vCFQ5VCFvRqFTT9Hr4F
         B1C/dL0yyVu1nRKT4yG+x692+v+RVBAWZadi+PJsg/taqOnhCTGvEj5UkyOb4KtFkCwt
         tJd7AZ6HoUoLnHKBPTTDotfsQPPQfFMxj0+MKYHwOPeu9Pe92VqBPjBJWGJXarWpgbFy
         q7MA==
X-Forwarded-Encrypted: i=1; AJvYcCUOf4JORuNtaqoNrC2Z+eklSz1Q7I5S+925rfsbxIrkAWEisbLp+1sLIeXwz4hz/rS55RGruYE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqKw3AwknsQipjJl1Ac1y0rPtf2JX0+NLaxGdYFDdrQ8EzvkI7
	CPQI8i8xwuA3HvZldWc3KS3S+VGr0+1R/XGK2XxtaQKCMEkdlD5VE+U7fvXq8upjMa+l6Ddxneu
	yQPXUZtkWB7RJtQ==
X-Google-Smtp-Source: AGHT+IEmoIr1XRdh2jEsRUDswYZqXhX3eoQiIFPX3VP+DLGDPoq40SIlYagZTuIw1RSOFbCoujpa5asPuE2+JQ==
X-Received: from wmbgz9-n1.prod.google.com ([2002:a05:600c:8889:10b0:471:1414:8fd1])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:37c3:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-47939e37b60mr41129515e9.27.1765077169581;
 Sat, 06 Dec 2025 19:12:49 -0800 (PST)
Date: Sun, 07 Dec 2025 03:12:48 +0000
In-Reply-To: <20251205165743.9341-1-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251205165743.9341-1-kalyazin@amazon.com>
X-Mailer: aerc 0.21.0
Message-ID: <DERNMX91W3P4.AHN53QLCCIH5@google.com>
Subject: Re: [PATCH v8 00/13] Direct Map Removal Support for guest_memfd
From: Brendan Jackman <jackmanb@google.com>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, 
	"kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, 
	"jmattson@google.com" <jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>, <owner-linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Fri Dec 5, 2025 at 4:57 PM UTC, Nikita Kalyazin wrote:
> Changes since v7:
>  - David: separate patches for adding x86 and ARM support
>  - Dave/Will: drop support for disabling TLB flushes

In case anyone was following along at home - it looks like
kvm_arch_gmem_supports_no_direct_map() has been refactored which also
fixes the can_set_direct_map() issue from [0].

[0] https://lore.kernel.org/kvm/DDWOP8GKHESP.2EOY2HGM9RXHU@google.com/#t
