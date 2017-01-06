From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH v2 2/5] arm64: Work around Falkor erratum 1003
Date: Fri, 6 Jan 2017 09:51:20 -0600
Message-ID: <4bf67a17-bb2f-cc1f-97c5-2d7c50604f60@codeaurora.org>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-2-cov@codeaurora.org>
 <1dfdc578-e0f8-1320-d223-c9c55e70ca93@codeaurora.org>
 <fd82e2bf-5259-2fda-c931-1996387d779f@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <fd82e2bf-5259-2fda-c931-1996387d779f@codeaurora.org>
Sender: linux-doc-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Christopher Covington wrote:
>> > Looks like you've made an unrelated whitespace change that affected the entire table,
>> > not just the line you're adding.
> I'm making space for "QCOM_FALKOR_ERRATUM_1003".

Ok, but you're also shrinking the other columns.  I think a better 
solution is to make the macro shorter. QCOM_ERRATUM_FLK1003?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
