Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD0F8829
	for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 23:57:46 +0000 (UTC)
Received: from MUA
	by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1pK6h3-0002mb-HH; Tue, 24 Jan 2023 00:57:41 +0100
Message-ID: <352ba836-f75a-9597-436a-ed42f4186dd3@maciej.szmigiero.name>
Date: Tue, 24 Jan 2023 00:57:35 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 2/2] KVM: selftests: Assign guest page size in sync area
 early in memslot_perf_test
Content-Language: en-US, pl-PL
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, seanjc@google.com, shan.gavin@gmail.com
References: <20230118092133.320003-1-gshan@redhat.com>
 <20230118092133.320003-3-gshan@redhat.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <20230118092133.320003-3-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.01.2023 10:21, Gavin Shan wrote:
> The guest page size in the synchronization area is needed by all test
> cases. So it's reasonable to set it in the unified preparation function
> (prepare_vm()).
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej

