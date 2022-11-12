Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592817B
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 10:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668247480;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YNPWveXNga0scY6/51aebupOAjiaIyJv8HXR04747GY=;
	b=hIUC5+5N1bVorX2AlebM/iZggLXen8MeQdrYWJaI0qtTeTMAJZ51WdK1WkVQ7Uq7+hNU9B
	w+4w1v2POs+iHMND+8YLfNmX7Jal1h6i0qLWwgN/Ks2hQ3q3czS9fHETY2sh1oPMsOczkv
	gyVzpoUTgx8M+n0AJZSrSEcEz9bcGsU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-23T7CmQMMxq2btIs--dQOw-1; Sat, 12 Nov 2022 05:04:37 -0500
X-MC-Unique: 23T7CmQMMxq2btIs--dQOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03D85101A528;
	Sat, 12 Nov 2022 10:04:37 +0000 (UTC)
Received: from [10.67.24.81] (unknown [10.67.24.81])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A8B8202322E;
	Sat, 12 Nov 2022 10:04:31 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Build access_tracking_perf_test for
 arm64
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
References: <20221111231946.944807-1-oliver.upton@linux.dev>
 <20221111231946.944807-3-oliver.upton@linux.dev>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <8a578b9d-b2a8-a1f9-2a8c-c0109c863723@redhat.com>
Date: Sat, 12 Nov 2022 18:04:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20221111231946.944807-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Message-ID: <20221112100426.q6W03YqhYqJgSqFXO7Bhpy34pCNkQkqrFrWCAC0op9s@z>

On 11/12/22 7:19 AM, Oliver Upton wrote:
> Does exactly what it says on the tin.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   tools/testing/selftests/kvm/Makefile | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 0172eb6cb6ee..4c0ff91a8964 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -156,6 +156,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/psci_test
>   TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
>   TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>   TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
> +TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
>   TEST_GEN_PROGS_aarch64 += demand_paging_test
>   TEST_GEN_PROGS_aarch64 += dirty_log_test
>   TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
> 

