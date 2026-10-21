Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792626411;
	b=vZu/UIcBpvfL6XPzySTU7Xqy5l+2D2qmvgJkbtJOZo6rOa/E5WiOU05dMVxaEJfZweBM
	 z+axb6lMOJn4luvAclE8NBNe0YbVWjYwUfW1lgSmN1gBzqEK8qnS/9aciL8r8+dYQoEDH
	 BQzILg57HvHhlH0sLM58tHgOJ6FfOl8VSzRqt3TqMX3jiRLzRiL2IHAgsYKqnaE9imdgL
	 RwG95EqU2BJxcpEh6eNrI0Eu4072NMtaIK1EeNAgBM929KGzrvBZEgiMTiq0k91MNTfxw
	 Tlw5cLPxShJSieLmpb34eLXC75wSAkxNsi6hXa25K3FwUrqUqrmUU6bFchA7Pfu8aFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792626411;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=n5hOymfjgaz7xpjT1ssIdHSQ+wD4cuNPKUAfRnejzdg=;
	b=oaRTtzczmlXFEe5kLFI8NSlDxk2yEhTk48SU74c1aL2dUEKybjpnB7s4sWyqM4gUhJKx
	 6rD9QcI9AF2UGcF+49yNz+7aaDddZofOHOhXaevFB7xy9tay3cdYCiPAUSUmGhIiCSubf
	 u/qSM4DjKOGt5ktH7i8gbkXdrkwLFSRnJw9lxBBlSH0v5OS3ALmGBTX2tW9bUN7EPudJS
	 fYlQaQQAjOPdjokhgWGr9DuapHkTp/wzqT21cktb0pq0B0bkwr7xunfpm8JWPUVhfr9tp
	 rrj4RFjqpnlq749g+Z53gIU7fUwofnhAVOobuFrwGK7dX7jHpBCt1fb/JoaEcLVzKBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81341606A31D
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 23:46:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81341606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f1cf92c9eso127759285a.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 16:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792626409; x=1793231209; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n5hOymfjgaz7xpjT1ssIdHSQ+wD4cuNPKUAfRnejzdg=;
        b=KWnBHPumlIiZl0jzg3lfqSXvwDJpx2Zrr9xZLlv8hQrkjgxNf7+qxnT6i21qYDF6t7
         nuUW1MTXrjaTVrm/v7f4En1Kz8OGvaJ4FMuwtVZ7wXpgCeHN7YY8z95A29mjWu/urkEx
         UkVNYUVetXsWN/qEgXvPuS9V3gVqh8oU45iwc6Y/gtuPQiebrSLUTMFBNNwo3Dkh3+CV
         IlqG3O1ZvgMbv7uS+hzHUXbdKL4b8FKZ1GZ/S6NNBBa86Dm78GJMLANoQbOLlMbcXUty
         fFEO0m2zSkJcSDDk6T4J3ZENCSqdGip5q5MGgmtX0wtIiOX4m3E4pgGnBFwLv0f4BBTe
         2PMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792626409; x=1793231209;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n5hOymfjgaz7xpjT1ssIdHSQ+wD4cuNPKUAfRnejzdg=;
        b=hLNGufdjBHT/zHMd7hznxi+FYLxoAiG5wHkTfAtc1pwJ5xTFUEPMPxH9QTZJHuWmB9
         6Q0vEQvIbuXnI1zknDlzjRPJ3wdRURAuWMGSGb/Y1RzUa3cWxlw1meHGr3qdcsyqGVoJ
         uXll46RiQjT0+AC99mRThHPkE8Mk4JzP3bo2tVkZQA94YZcta2iX9yiKNqP+bERFf97J
         6hW+L21x1nt24DE2ALfdSKCrqXMQPpi6j6rHR463CsRK3vi2VLzo+0KJkKiMRfKysupK
         UkyUJvvz7Y4r4GDFzBnoJ06wKjI45rpzvIB7AiPcSWVwn7khAK+qgDgpKJQ6zDSGYC9D
         V8DA==
X-Forwarded-Encrypted: i=1; AKwUvByoGQv+2ZhoJuajTgi7Z3QgFO4Y+a5ZoV9519o9V2dfqhgCy/QbSfR2MllRYKrWRXcAn92gm7Y=@lists.linux.dev
X-Gm-Message-State: AFq9FYIb1+n6WKwOCxbyjPZBKWeGVoUj1nXrrrIdE70TUus1beclFAYe
	4JytgvSFWYVWF3Y538YAkDTiSKdgPi0uHix5ivesXyv7qdabXS3GG7OAWD2abWDHq3A=
X-Gm-Gg: AYBFou1tnaevRbMQ5S7D2FPxsNj2GJJgyfWDP+PiwCDybaeD4FnTj3OK5/VHYTt4WGo
	Cn183Yl2RLm90dX4okqrpt6dN4jgpQ30LACLcwYNjXqOmrZE+91RRydDW+DKWaO27jBb2l8Vd8X
	AIy9VeUGPrIaxu0u/AiMMESfKy7PLMtCvusPwZmhgVq0irNqhOxCg0xgGU3OdZzlEZb6nT9U2T0
	Sa+MfmjxDIpQLOE1P3p/YhbxX0PSl4M29IzP3AupYkYkhanTe2Gi62KVqmTBrGZM/Qk293TcjUZ
	UDq1ZhmPJBZS+IqXAjscjdo61S5PGuaH+i4lFF47EOC+idYpyQRy4fRdEVOhsWug3xFnkadWrcp
	rF5cS4XQINtmQsqRW/0z2auS/7a05sC4CoaGoq/JTpS/YbTtQJn451IwhVJJnzcfh7e8gTK9wGA
	wUPgpa0FEX4pDe3wN8EBGPws4RctjUK9mJdqz8+BGUyK8dm7KQgT/WfpBnvuJRAzY8EsYUP6eSw
	3sy0r/gXTl3ffmO14jhtxvI+z5Igum2/Zqp4SwWvRwWU0OJApFQD/dRS2ZsAUczsWQTy6YmGX25
	sg4VmkKe48DlJA/5XxaJ656hcmHcwugwUV8L0Qk3zUfXaFRdF+oNYizBpcM=
X-Received: by 2002:a05:620a:17a1:b0:93f:22f1:97be with SMTP id af79cd13be357-93f5800e406mr694136885a.72.1792626409239;
        Wed, 21 Oct 2026 16:46:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e2bee2sm373858385a.42.2026.10.21.16.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:46:48 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xJg19-0000000EWG8-3cjA;
	Wed, 21 Oct 2026 20:46:47 -0300
Date: Wed, 21 Oct 2026 20:46:47 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 06/11] iommufd: Map memory provider files
Message-ID: <20261021234647.GA3381610@ziepe.ca>
References: <20261014093733.90312-1-griffoul@gmail.com>
 <20261014093733.90312-7-griffoul@gmail.com>
 <atkO08eCJzLX6R58@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atkO08eCJzLX6R58@google.com>

On Wed, Oct 21, 2026 at 08:17:05PM +0000, Samiullah Khawaja wrote:

> With this approach, silently skipping holes during IOAS_MAP_FILE means
> iommufd has no tracking of which IOVA ranges in the area are actually
> mapped, which complicates unmap and could also hide a bug if a hole in
> the range was not expected?

I think if we are going to do this it should only work with iommupt
and iommupt should provide an unmap that is compatible with the holes.

There are other places that would like such an operation, IIRC.

This will have to block an access reaching into a guest memfd mapping
as well, so that should be OK.

Jason
