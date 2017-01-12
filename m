From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 4/6] docs: mention checkpatch in the README
Date: Thu, 12 Jan 2017 13:29:52 +0100
Message-ID: <322298cd-aefa-e945-d3f4-1237767a06ef@redhat.com>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-5-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170111162841.15569-5-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, drjones@redhat.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu



On 11/01/2017 17:28, Alex Bennée wrote:
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  README.md | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/README.md b/README.md
> index 5027b62..9462824 100644
> --- a/README.md
> +++ b/README.md
> @@ -79,3 +79,4 @@ You can add the following to .git/config to do this automatically for you:
>      [format]
>          subjectprefix = kvm-unit-tests PATCH
>  
> +Please run the kernel's ./scripts/checkpatch.pl on new patches

Does it really work well on kvm-unit-tests?

Paolo
