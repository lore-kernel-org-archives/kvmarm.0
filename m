Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1AE4408
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 00:03:20 +0000 (UTC)
Received: from MUA
	by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1pK6gP-0002m1-GC; Tue, 24 Jan 2023 00:57:01 +0100
Message-ID: <b5a6f902-2d43-a7d6-5840-669760b6c9d7@maciej.szmigiero.name>
Date: Tue, 24 Jan 2023 00:56:55 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US, pl-PL
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, seanjc@google.com, shan.gavin@gmail.com
References: <20230118092133.320003-1-gshan@redhat.com>
 <20230118092133.320003-2-gshan@redhat.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 1/2] KVM: selftests: Remove duplicate VM in
 memslot_perf_test
In-Reply-To: <20230118092133.320003-2-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.01.2023 10:21, Gavin Shan wrote:
> There are two VMs created in prepare_vm(), which isn't necessary.
> To remove the second created and unnecessary VM.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>

It's weird that we ended with two __vm_create_with_one_vcpu() calls,
it looks like the second one was accidentally (re-)introduced during
'kvmarm-6.2' merge, so maybe?:
Fixes: eb5618911af0 ("Merge tag 'kvmarm-6.2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")

Anyway, thanks for spotting this:
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej

