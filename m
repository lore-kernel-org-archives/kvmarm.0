Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197CC14B941
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 22:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722550351; cv=none; b=iUqUG4cP1rQb2xFtGOEu09sOMBpWS6+UtBSUdCP9HsDFwSQy4JF8UHcIMe9zC/f4FwefAavpste3Gj4GHehDoSuW3F5UMWvq7EwbBrZpoMbWGnOhD62on2Mvg5eH5E8UrVblzs6ziMwYSJjEJxDhCRfFtuFJA1HZ+Yr4F+gJhho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722550351; c=relaxed/simple;
	bh=0UTEUABwLl9nPHyasmA3Zw/bHjsSB/lUKnDNzfoDXeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=iGIRl2amiwKgbS1OZ1LNgXSqwShe7moGOhOF0deXzcORt5lxjTyUUdHU++dRUcF43ZudHSD4nTLu+B1Yn5K6129Xvzh4Vu/KC1uUbypiTEcNJYnzFU1NJK6WpjfzWrm/LBXF5JhjKsZk+SrJU+1wi8FtBGw3DwbkoyfdONYuDr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MWC2XevP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MWC2XevP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722550349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oEkakUjv0oShqAlgA+JoFFoT773rpEPOk5LHphGKBXA=;
	b=MWC2XevPWxNDw4qHj4RffqWocP21wC3ik63MipWViTP9C6o5TbEGIjsvw9iPXyxMX7AEca
	gtZbob4SnkGUsEMYy/IWagT1nwxgDzsdkVsfLv1/wWMGMI3dr3Xw8ZbumLyHzvZNUZqbFs
	nX0CCY97dfgrktqxacWmXQaz2w+U7Ww=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-sTA-kqEuPnCMiONJ8EKQZg-1; Thu, 01 Aug 2024 18:12:27 -0400
X-MC-Unique: sTA-kqEuPnCMiONJ8EKQZg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6b79c5c972eso9487996d6.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Aug 2024 15:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722550347; x=1723155147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEkakUjv0oShqAlgA+JoFFoT773rpEPOk5LHphGKBXA=;
        b=iKxNZLq+v1d2f5aefn/mth0beiXCHHFZmXDF824lrd//Aa6pj71aEoiRZVaT3s77X6
         S7uT4JFv7UiyH4pOwSXmGugYNMGcVs5w9vCFZp5z5/nXm0J5GLfaeWEPbB3UTuXeqoEc
         u5reOCF3+A+piCZ3bkp5ssROfnMKDNc1er7OrBa42bLIBdm/IX5PsQrXIsckY2BRs18x
         LmIQx0K5+3dOLPNe3POxu7ZFw/zfWQWLYHrHwikUd30SU12nJXeIrqFvQsc3Rt+I453P
         s+SoJSusryjr1Qk6+cpQaS7QbmGxZYeXkiNV8QE8QwpYBPDI4WHuFBO2qZ9M3nPumz4+
         fzXA==
X-Forwarded-Encrypted: i=1; AJvYcCW/QzUDAzxwSrlkrbrlViPWZrtCrMHRIbsGmwuTuWOSlo+hqUe2YFjhERBAp4sH29La4+kLb38=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx78tYWyyXAKB64yEqqKQiNimszVIynzuL/D64Yiawdu8UttoEj
	fNffH8dCYQuCzULtFzaSHjD7LxTIGCJFnOMM5Ir/enK5Y7SgMZyHgiO1OYrn6tTWUfJJirgF67L
	6J6cBOnDHTWD7KWbp5xzKAfSGYSBTmK5oFu2T/DHo1EVhmdqHDQHguA==
X-Received: by 2002:a05:6214:c48:b0:6b7:586c:2cf9 with SMTP id 6a1803df08f44-6bb98477071mr10740516d6.8.1722550347291;
        Thu, 01 Aug 2024 15:12:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYiPlQnhQgnszBxOlYnmcmzkuBRtiLsO/YtZH3gTULjwGEVWYGXNe4E6cY2VjLct5v9IMvig==
X-Received: by 2002:a05:6214:c48:b0:6b7:586c:2cf9 with SMTP id 6a1803df08f44-6bb98477071mr10740356d6.8.1722550346938;
        Thu, 01 Aug 2024 15:12:26 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c77099asm1039296d6.12.2024.08.01.15.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 15:12:26 -0700 (PDT)
Date: Thu, 1 Aug 2024 18:12:23 -0400
From: Peter Xu <peterx@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
Message-ID: <ZqwIR8HW0d0cXAhq@x1n>
References: <20240710234222.2333120-1-jthoughton@google.com>
 <CADrL8HUHRMwUPhr7jLLBgD9YLFAnVHc=N-C=8er-x6GUtV97pQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CADrL8HUHRMwUPhr7jLLBgD9YLFAnVHc=N-C=8er-x6GUtV97pQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Jul 10, 2024 at 04:48:36PM -0700, James Houghton wrote:
> Ah, I put the wrong email for Peter! I'm so sorry!

So I have a pure (and even stupid) question to ask before the rest of
details.. it's pure question because I know little on guest_memfd,
especially on the future plans.

So.. Is there any chance guest_memfd can in the future provide 1G normal
(!CoCo) pages?  If yes, are these pages GUP-able, and mapp-able?

Thanks,

-- 
Peter Xu

