From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH v4 2/4] arm64: Work around Falkor erratum 1003
Date: Fri, 27 Jan 2017 13:18:15 -0600
Message-ID: <6ff1f71f-8d28-81cb-b4b5-0617604ba153@codeaurora.org>
References: <20170125155232.10277-1-cov@codeaurora.org>
 <20170125155232.10277-2-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170125155232.10277-2-cov@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christopher Covington <cov@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc: Jon Masters <jcm@redhat.com>, Neil Leeder <nleeder@codeaurora.org>, Mark Langsdorf <mlangsdo@redhat.com>, Mark Salter <msalter@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/25/2017 09:52 AM, Christopher Covington wrote:
> +		.desc = "Qualcomm Falkor erratum 1003",

FYI, this needs to say, "Qualcomm Technologies Falkor ...".  Same thing with 
the 1009 patch.

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc.  Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
