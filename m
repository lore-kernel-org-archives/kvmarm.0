Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01F6110B
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 15:27:28 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68E7D1FB;
	Thu,  2 Mar 2023 07:28:11 -0800 (PST)
Received: from [10.1.30.161] (C02CF1NRLVDN.cambridge.arm.com [10.1.30.161])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DE1E3F67D;
	Thu,  2 Mar 2023 07:27:27 -0800 (PST)
Message-ID: <e8ed178a-0c67-3e00-a085-1d88fb3cb41f@arm.com>
Date: Thu, 2 Mar 2023 15:27:26 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v1 0/2] KVM: selftests: Fixes for broken tests
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev
References: <20230228170756.769461-1-ryan.roberts@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20230228170756.769461-1-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/02/2023 17:07, Ryan Roberts wrote:
> During the course of implementing FEAT_LPA2 within the arm64 KVM port, I found a
> couple of issues within the KVM selftest code, which I thought were worth
> posting independently. The LPA2 patches, for which I will post v2 in the next
> few days, depend on these fixes for its testing.

It turned out that there was another issue, for which I have posted a fix at
https://lore.kernel.org/kvmarm/20230302152033.242073-1-ryan.roberts@arm.com/

With these 3 fixes, I see a clean run of the kvm selftests with the 64K kernel +
FEAT_LPA on FVP.

Thanks,
Ryan


> 
> Ryan Roberts (2):
>   KVM: selftests: Fixup config fragment for access_tracking_perf_test
>   KVM: selftests: arm64: Fix pte encode/decode for PA bits > 48
> 
>  tools/testing/selftests/kvm/config            |  1 +
>  .../selftests/kvm/lib/aarch64/processor.c     | 32 ++++++++++++++-----
>  2 files changed, 25 insertions(+), 8 deletions(-)
> 
> --
> 2.25.1
> 

