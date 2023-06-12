Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C554134AE
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 10:43:57 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38FADD75;
	Mon, 12 Jun 2023 03:44:42 -0700 (PDT)
Received: from [192.168.13.137] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74F343F663;
	Mon, 12 Jun 2023 03:43:55 -0700 (PDT)
Message-ID: <e4146d20-863c-03ea-748d-695532d2ace0@arm.com>
Date: Mon, 12 Jun 2023 11:43:53 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Content-Language: en-GB
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, Nadav Amit <nadav.amit@gmail.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com,
 ricarkol@google.com, shahuang@redhat.com
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
 <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
 <20230612-a9f763ef517c2c5fe728bc38@orel>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230612-a9f763ef517c2c5fe728bc38@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/06/2023 11:41, Andrew Jones wrote:
>> Let me know if you want me to send a patch for this.
> 
> Yes, please, but we also don't have to hold this series up by it, since we
> agreed that this series was focused on EFI over QEMU as a first step.
> We'll need to worry about zeroing memory and more when we start running
> on bare-metal.
> 
> To be clear, the patch for this can be on top of this series.
> 

Thanks. I'll add this as a todo for the next series.

Thanks,

Nikos
